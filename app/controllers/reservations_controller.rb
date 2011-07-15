class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  
  def index
    @reservations = Reservation.all
    if current_user.admin?
      @reservations = Reservation.all
    else
      @reservations = Reservation.find(:all, :conditions => {:user_id => current_user.id})
    end 
  end

  def new
    @reservation = Reservation.new
    @reservable_asset = params[:reservable_asset]
    @max_time = ReservableAsset.find(@reservable_asset).max_reservation_time
    @min_time = ReservableAsset.find(@reservable_asset).min_reservation_time
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @reservable_asset = @reservation.reservable_asset_id
    @max_time = ReservableAsset.find(@reservable_asset).max_reservation_time
    @min_time = ReservableAsset.find(@reservable_asset).min_reservation_time
  end
  
  def create
    @reservation = Reservation.new
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset_id])
    if current_user.admin?
      params[:reservation][:user] = User.find(params[:reservation][:user_id])
    else
      params[:reservation][:user] = User.find(current_user)
    end
    
    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    end  
    
    #saving the actual date entered in by the user to validate date range on line 53
    chosen = Date.parse(params[:reservation][:end_date], "{ %Y, %m, %d }")
    
    #setting the end date to the last day of the month chosen by the user
    params[:reservation][:end_date] = Date.civil(params[:reservation][:end_date].split('/')[2].to_i, params[:reservation][:end_date].split('/')[0].to_i, -1).strftime("%m/%d/%Y")
    
    @reservation.attributes = params[:reservation]
    
    respond_to do|format|
      if @reservation.date_valid?(@reservation.start_date, chosen)
      
        if @reservation.save
          p @reservation.end_date
          p @reservation.end_date.class
          Notification.reservation_notice(@reservation).deliver
          flash[:notice] = 'Added that Reservation'
          format.html {render :action => :show}
        else
          flash[:error] = 'Could not add that Reservation'
          format.html {render :action => :new, :reservable_asset => params[:reservation][:reservable_asset]}
        end
      else
        flash[:error] = 'Dates selected are not valid'
        format.html {render :action => :new, :reservable_asset => params[:reservation][:reservable_asset]}
      end    
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    reservation = @reservation
    if @reservation.destroy
      Notification.reservation_canceled(reservation).deliver
      flash[:notice] = %Q|Deleted reservation #{reservation.id}|
      redirect_to :back
    else

    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    prev_status = @reservation.status
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset_id])
    @reservation.attributes = params[:reservation]
    
    respond_to do|format|
      if @reservation.save
        Notification.reservation_notice(@reservation).deliver
        flash[:notice] = %Q|#{@reservation} updated|
        format.html {redirect_to :action => :show}
      else
        flash[:error] = 'Could not update that Reservation'
        format.html {render :action => :new}
      end
    end
  end
end
