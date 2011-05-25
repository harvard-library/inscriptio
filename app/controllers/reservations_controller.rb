class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  
  def index
    @reservations = Reservation.all
    if admin_signed_in?
      @reservations = Reservation.all
    else
      @reservations = Reservation.find(:all, :conditions => {:user_id => current_user.id})
    end 
  end

  def new
    @reservation = Reservation.new
    @reservable_asset = params[:reservable_asset]
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @reservable_asset = @reservation.reservable_asset_id
  end
  
  def create
    @reservation = Reservation.new
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset])
    params[:reservation][:user] = User.find(current_user)
    @reservation.attributes = params[:reservation]
    respond_to do|format|
      if @reservation.save
        flash[:notice] = 'Added that Reservation'
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not add that Reservation'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    reservable_asset = @reservation.id
    if @reservation.destroy
      flash[:notice] = %Q|Deleted reservation #{reservation}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset])
    @reservation.attributes = params[:reservation]
    respond_to do|format|
      if @reservation.save
        flash[:notice] = %Q|#{@reservation} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Reservation'
        format.html {render :action => :new}
      end
    end
  end
end
