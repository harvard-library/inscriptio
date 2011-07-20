class FloorsController < ApplicationController
  before_filter :load_library
  before_filter :authenticate_admin!, :except => [:index, :show]

  def index
    @floors = @library.floors
  end

  def new
    @floor = Floor.new
  end

  def create
    @floor = Floor.new
    @floor.attributes = params[:floor]
    respond_to do|format|
      if @floor.save
        flash[:notice] = 'Added that floor'
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not add that floor'
        format.html {render :action => :new}
      end
    end
  end

  def edit
    @floor = Floor.find(params[:id])
  end

  def update
    @floor = Floor.find(params[:id])
    @floor.attributes = params[:floor]
    respond_to do|format|
      if @floor.save
        flash[:notice] = %Q|#{@floor.name} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that floor'
        format.html {render :action => :new}
      end
    end
  end

  def move_higher
    @floor = Floor.find(params[:id])
    unless @floor.first?
      @floor.move_higher
      flash[:notice] = "Moved #{@floor.name} up"
      redirect_to :back
    end
  end

  def move_lower
    @floor = Floor.find(params[:id])
    unless @floor.last?
      @floor.move_lower
      flash[:notice] = "Moved #{@floor.name} down"
      redirect_to :back
    end
  end

  def show
    @floor = Floor.find(params[:id])
    
    breadcrumbs.add @floor.library.name, library_path(@floor.library.id)
    breadcrumbs.add @floor.name, @floor.id
  end

  def destroy
    @floor = Floor.find(params[:id])
    library = @floor.library
    floor_name = @floor.name
    if @floor.destroy
      flash[:notice] = %Q|Deleted floor #{floor_name}|
      redirect_to library
    else

    end
  end

  def assets
    floor = Floor.find(params[:id])
    assets = floor.reservable_assets
    respond_to do |format|
      format.json {
        output = assets.map { |asset| 
          {
            :id => asset.id,
            :name => asset.name,
            :x1 => asset.x1,
            :y1 => asset.y1,
            :x2 => asset.x2,
            :y2 => asset.y2,
            :allow_reservation => asset.allow_reservation?(current_user)
          }
        }
        render :json => output
      }
    end
  end

  private

  def load_library
    @library = Library.find(params[:library_id])
  end

end
