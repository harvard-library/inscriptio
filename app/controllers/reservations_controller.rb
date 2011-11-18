class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  
  def index
    if current_user.admin?
      @reservations = Reservation.all
    else
      @pending = Reservation.find(:all, :conditions => {:user_id => current_user.id, :status_id => Status.find(:first, :conditions => ["lower(name) = 'pending'"])}, :order => ['created_at DESC'])
      @active = Reservation.find(:all, :conditions => {:user_id => current_user.id, :status_id => Status.find(:first, :conditions => ["lower(name) = 'approved'"])}, :order => ['created_at DESC'])
      @expired = Reservation.find(:all, :conditions => {:user_id => current_user.id, :status_id => Status.find(:first, :conditions => ["lower(name) = 'expired'"])}, :order => ['created_at DESC'])
    end 
    
    breadcrumbs.add 'Reservations'
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
    unless params[:renew].nil?
      @renew = true
    end  
  end
  
  def create
    @reservation = Reservation.new
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset_id])
    params[:tos] == "Yes" ? params[:reservation][:tos] = true : params[:reservation][:tos] = false
    current_user.admin? ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
      else
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
      end    
    end  
    
    #saving the actual date entered in by the user to validate date range below    
    chosen = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
    params[:reservation][:start_date] = Date.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    
    #setting the end date to the last day of the month chosen by the user
    params[:reservation][:end_date] = Date.civil(params[:reservation][:end_date].split('/')[2].to_i, params[:reservation][:end_date].split('/')[0].to_i, -1)
        
    @reservation.attributes = params[:reservation]
    
    respond_to do|format|
      if @reservation.reservable_asset.allow_reservation?(current_user)
        if @reservation.date_valid?(params[:reservation][:start_date], chosen)
          # if last day of current month is over max reservation time then use last day of previous month
          time_in_days = (@reservation.end_date - @reservation.start_date).to_i
          if time_in_days > @reservation.reservable_asset.max_reservation_time.to_i
            @reservation.end_date = Date.civil(@reservation.end_date.year, Date.civil(@reservation.end_date.year, @reservation.end_date.month, -1).prev_month.month, -1)
          end
          @reservation.slot = @reservation.assign_slot
          if @reservation.save
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
      else
          flash[:notice] = 'You are not able to reserve this asset at this time.'
          format.html {redirect_to reservations_path}
      end       
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    reservation = @reservation
    if @reservation.destroy
      flash[:notice] = %Q|Deleted reservation #{reservation.id}|
      redirect_to :back
    end
  end

  def update
    @reservation = Reservation.find(params[:id])
    prev_status = @reservation.status
    params[:reservation][:reservable_asset] = ReservableAsset.find(params[:reservation][:reservable_asset_id])
    
    params[:tos] == "Yes" ? params[:reservation][:tos] = true : params[:reservation][:tos] = false
    current_user.admin? ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
      else
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
      end    
    end  
    
    #saving the actual date entered in by the user to validate date range below    
    chosen = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
    params[:reservation][:start_date] = Date.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    
    #setting the end date to the last day of the month chosen by the user
    params[:reservation][:end_date] = Date.civil(params[:reservation][:end_date].split('/')[2].to_i, params[:reservation][:end_date].split('/')[0].to_i, -1)
    @reservation.attributes = params[:reservation]
    respond_to do |format|
      if @reservation.date_valid?(params[:reservation][:start_date], chosen)
        # if last day of current month is over max reservation time then use last day of previous month
        time_in_days = (@reservation.end_date - @reservation.start_date).to_i
        if time_in_days > @reservation.reservable_asset.max_reservation_time.to_i
          @reservation.end_date = Date.civil(@reservation.end_date.year, Date.civil(@reservation.end_date.year, @reservation.end_date.month, -1).prev_month.month, -1)
        end
        if @reservation.save
          flash[:notice] = %Q|Reservation updated|
          format.html {redirect_to :action => :show}
        else
          flash[:error] = 'Could not update that Reservation'
          format.html {redirect_to new_reservation_path(:reservable_asset => @reservation.reservable_asset)}
        end
      else  
        flash[:error] = 'Could not update that Reservation'
        format.html {redirect_to new_reservation_path(:reservable_asset => @reservation.reservable_asset)} 
      end 
    end
  end 
  
end
