class ReservationExpirationNoticesController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @reservation_expiration_notices = ReservationExpirationNotice.all
  end

  def new
    @reservation_expiration_notice = ReservationExpirationNotice.new
  end

  def show
    @reservation_expiration_notice = ReservationExpirationNotice.find(params[:id])
  end

  def edit
    @reservation_expiration_notice = ReservationExpirationNotice.find(params[:id])
  end
  
  def create
    @reservation_expiration_notice = ReservationExpirationNotice.new
    @reservation_expiration_notice.attributes = params[:reservation_expiration_notice]
    respond_to do|format|
      if @reservation_expiration_notice.save
        flash[:notice] = 'Added that Reservation Expiration Notice'
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not add that Reservation Expiration Notice'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservation_expiration_notice = ReservationExpirationNotice.find(params[:id])
    reservation_expiration_notice = @reservation_expiration_notice.type
    if @reservation_expiration_notice.destroy
      flash[:notice] = %Q|Deleted Reservation Expiration Notice #{reservation_expiration_notice}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @reservation_expiration_notice = ReservationExpirationNotice.find(params[:id])
    @reservation_expiration_notice.attributes = params[:reservation_expiration_notice]
    respond_to do|format|
      if @reservation_expiration_notice.save
        flash[:notice] = %Q|#{@reservation_expiration_notice} updated|
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not update that Reservation Expiration Notice'
        format.html {render :action => :new}
      end
    end
  end
end
