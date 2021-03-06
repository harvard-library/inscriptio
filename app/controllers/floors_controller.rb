class FloorsController < ApplicationController
  load_and_authorize_resource :library
  load_and_authorize_resource :floor, :through => :library

  def create
    @floor.attributes = floor_params
    @floor.library = @library
    respond_to do|format|
      if @floor.save
        flash.now[:notice] = 'Added that floor'
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not add that floor'
        format.html {render :action => :new}
      end
    end
  end

  def update
    @floor.attributes = floor_params
    @floor.library = @library
    respond_to do|format|
      if @floor.save
        flash.now[:notice] = %Q|#{@floor.name} updated|
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not update that floor'
        format.html {render :action => :new}
      end
    end
  end

  def move_higher
    unless @floor.first?
      @floor.move_higher
      flash[:notice] = "Moved #{@floor.name} up"
    else
      flash[:notice] = "#{@floor.name} is already as high as it can be."
    end
    redirect_to :back
  end

  def move_lower
    unless @floor.last?
      @floor.move_lower
      flash[:notice] = "Moved #{@floor.name} down"
    else
      flash[:notice] = "#{@floor.name} is already as low as it can be."
    end
    redirect_to :back
  end

  def show
    @library = @floor.library
    @suppress_actions = true # Note: partials check for nil?, not false
    breadcrumbs.add @floor.library.name, library_path(@floor.library.id)
    breadcrumbs.add @floor.name, @floor.id
  end

  def destroy
    library = @floor.library
    floor_name = @floor.name
    if @floor.destroy
      flash[:notice] = %Q|Deleted floor #{floor_name}|
      redirect_to library
    end
  end

  def assets
    assets = @floor.reservable_assets
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
            :allow_reservation => !asset.full? && can?(:reserve, asset)
          }
        }
        render :json => output
      }
    end
  end
  private
  def floor_params
    # special handling for array params.  Also: subject_area_ids and reservable_asset_ids are via association
    f_params = params.require(:floor).permit( :name, :floor_map, :position, :call_number_ids)
    f_params[:call_number_ids] =  params[:floor][:call_number_ids]
    f_params
  end
end
