class ReservationNoticesController < ApplicationController
  load_and_authorize_resource

  def index
    if current_user.admin?
      @libraries = Library.all
    else
      @libraries = current_user.local_admin_permissions
    end
    breadcrumbs.add "Reservation Notices"
  end

  def destroy
    reservation_notice = @reservation_notice.type
    if @reservation_notice.destroy
      flash[:notice] = %Q|Deleted Reservation Notice #{reservation_notice}|
      redirect_to :action => :index
    end
  end

  def update
    @reservation_notice.attributes = params[:reservation_notice]
    respond_to do|format|
      if @reservation_notice.save
        flash[:notice] = %Q|#{@reservation_notice.subject} updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not update that Reservation Notice'
        format.html {render :action => :new}
      end
    end
  end

  def reset_notices
    asset_type = ReservableAssetType.find(params[:asset_type])
    ReservationNotice.regenerate_notices(asset_type)
    redirect_to reservation_notices_path
  end

end
