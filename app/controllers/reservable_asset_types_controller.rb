class ReservableAssetTypesController < ApplicationController
  before_filter :fetch_permitted_libraries, :only => [:index]
  load_and_authorize_resource :except => [:new]
  load_resource :only => [:new]

  def fetch_permitted_libraries
    @libraries = current_user.admin? ? Library.all : current_user.local_admin_permissions
  end

  def index
    breadcrumbs.add 'Reservable Assets'
  end

  def new
    @reservable_asset_type.library = Library.find(params[:library_id])
    authorize! :manage, @reservable_asset_type
  end

  def create
    respond_to do|format|
      if @reservable_asset_type.slots_equal_users?
        if @reservable_asset_type.save
          flash[:notice] = 'Added that Reservable Asset Type'
          format.html {render :action => :show}
        else
          flash[:error] = 'Could not add that Reservable Asset Type'
          format.html {render :action => :new}
        end
      else
        flash[:error] = 'Number of slots does not match number of concurrent users.'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservable_asset_type = ReservableAssetType.find(params[:id])
    reservable_asset_type = @reservable_asset_type.name
    if @reservable_asset_type.destroy
      flash[:notice] = %Q|Deleted reservable asset type #{reservable_asset_type}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @reservable_asset_type = ReservableAssetType.find(params[:id])
    @reservable_asset_type.attributes = params[:reservable_asset_type]
    respond_to do|format|
      if @reservable_asset_type.slots_equal_users?
        if @reservable_asset_type.save
          flash[:notice] = %Q|#{@reservable_asset_type} updated|
          format.html {render :action => :show}
        else
          flash[:error] = 'Could not update that Reservable Asset Type'
          format.html {render :action => :new}
        end
      else
        flash[:error] = 'Number of slots does not match number of concurrent users.'
        format.html {render :action => :new}
      end
    end
  end
end
