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
    authorize! :create, @reservable_asset_type
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
    @reservable_asset_type.attributes = reservable_asset_type_params
    respond_to do|format|
      if @reservable_asset_type.slots_equal_users?
        if @reservable_asset_type.save
          flash.now[:notice] = %Q|#{@reservable_asset_type} updated|
          format.html {render :action => :show}
        else
          flash.now[:error] = 'Could not update that Reservable Asset Type'
          format.html {render :action => :new}
        end
      else
        flash.now[:error] = 'Number of slots does not match number of concurrent users.'
        format.html {render :action => :new}
      end
    end
  end
  private
  def reservable_asset_type_params
    # special handling for potential array
    rat_params = params.require(:reservable_asset_type).permit(:library_id, :user_type_ids,
                   :name,:min_reservation_time, :max_reservation_time, :expiration_extension_time,
                   :max_concurrent_users, :has_code, :has_bulletin_board, :require_moderation,
                   :welcome_message, :photo,  :slots )
    rat_params[:user_type_ids] = params[:reservable_asset_type][:user_type_ids]
    rat_params
  end
end
