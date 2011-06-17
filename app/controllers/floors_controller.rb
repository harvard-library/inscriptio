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
      redirect_to :action => :index
    end
  end

  def move_lower
    @floor = Floor.find(params[:id])
    unless @floor.last?
      @floor.move_lower
      flash[:notice] = "Moved #{@floor.name} down"
      redirect_to :action => :index
    end
  end

  def show
    @floor = Floor.find(params[:id])
  end

  def destroy
    @floor = Floor.find(params[:id])
    floor_name = @floor.name
    if @floor.destroy
      flash[:notice] = %Q|Deleted floor #{floor_name}|
      redirect_to :action => :index
    else

    end
  end

  def assets
    floor = Floor.find(params[:id])
    assets = floor.reservable_assets
    respond_to do |format|
      format.json {
        render :json => assets.to_json(:only => [:id, :name, :x1, :y1, :x2, :y2])
      }
    end
  end

  private

  def load_library
    @library = Library.find(params[:library_id])
  end

end
