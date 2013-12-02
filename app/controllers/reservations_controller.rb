class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  before_filter :process_dates, :only => [:create, :update]

  def process_dates
    params[:reservation][:start_date] = Date.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    params[:reservation][:end_date] = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
  end

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

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end

    @reservable_asset = @reservation.reservable_asset
    @max_time = ReservableAsset.find(@reservable_asset).max_reservation_time
    @min_time = ReservableAsset.find(@reservable_asset).min_reservation_time
    unless params[:renew].nil?
      @renew = true
    end
  end

  def create
    @reservation = Reservation.new
    params[:reservation][:reservable_asset] = defined?(@reservable_asset) ? @reservable_asset : ReservableAsset.find(params[:reservation][:reservable_asset_id])
    params[:tos] == "Yes" ? params[:reservation][:tos] = true : params[:reservation][:tos] = false
    current_user.admin? ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
      else
        params[:reservation][:status] = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
      end
    end

    @reservation.attributes = params[:reservation]
    @reservation.slot = @reservation.assign_slot
    respond_to do |format|
      if @reservation.save
        flash[:notice] = 'Added that Reservation'
        format.html { redirect_to @reservation }
      else
        flash[:error] = "Reservation could not be saved."
        @reservable_asset = @reservation.reservable_asset
        format.html{ render :action => :new }
      end
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end

    reservation = @reservation
    if @reservation.destroy
      flash[:notice] = %Q|Deleted reservation #{reservation.id}|
      if request.referer.match(/#{reservation.id}$/)
        redirect_to ('/')
      else
        redirect_to :back
      end
    end
  end

  def update
    @reservation = Reservation.find(params[:id])

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end

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

    @reservation.attributes = params[:reservation]
    respond_to do |format|
      if @reservation.save
        flash[:notice] = %Q|Reservation updated|
        format.html { redirect_to @reservation }
      else
        flash[:error] = 'Could not update that Reservation'
        format.html {redirect_to new_reservation_path(:reservable_asset => @reservation.reservable_asset)}
      end
    end
  end
end
