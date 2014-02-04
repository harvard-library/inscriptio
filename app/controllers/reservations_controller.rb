class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  before_filter :process_dates, :only => [:create, :update]
  before_filter :authenticate_admin!, :only => [:index]

  def process_dates
    params[:reservation][:start_date] = Date.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    params[:reservation][:end_date] = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
  end

  def index
    rel = Library.includes(:reservable_asset_types => {:reservable_assets => {:reservations => :user}})
    rel = rel.where("status_id IN (?)", Status[:pending, :expired, :approved, :expiring])
    rel = rel.where('reservations.deleted_at IS NULL')
    @libraries = rel.order('libraries.id, reservable_asset_types.id, users.email')

    # The output of the following nested reduce is a nested hash of arrays of Reservations,
    # keyed by [:library_id][:reservable_asset_type_id][:status_name]
    @reservations = @libraries.reduce({}) do |libs, l|
      libs[l.id] = l.reservable_asset_types.reduce({}) do |rats, rat|
        rats[rat.id] = rat.reservable_assets.reduce({}) do |ras, ra|
          ra.reservations.each do |r|
            case r.status_id
            when Status[:pending]
              ras['Pending'] ? ras['Pending'].push(r) : (ras['Pending'] = [r])
            when Status[:expired]
              ras['Expired'] ? ras['Expired'].push(r) : (ras['Expired'] = [r])
            when Status[:approved], Status[:expiring]
              ras['Approved'] ? ras['Approved'].push(r) : (ras['Approved'] = [r])
            end
          end;ras
        end;rats
      end;libs
    end

    breadcrumbs.add 'Reservations'
  end

  def new
    @reservation = Reservation.new
    @reservable_asset = ReservableAsset.find(params[:reservable_asset])
    @max_time = ReservableAsset.find(@reservable_asset).max_reservation_time
    @min_time = ReservableAsset.find(@reservable_asset).min_reservation_time
  end

  def show
    relation = Reservation
    relation = relation.with_deleted if current_user.admin?
    @reservation = relation.find(params[:id])

    @del_or_clear = @reservation.deleted_at ? 'Delete' : 'Clear'

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end
  end

  def edit
    relation = Reservation
    relation = relation.with_deleted if current_user.admin?
    @reservation = relation.find(params[:id])

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
    current_user.admin? ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status_id] = Status[:pending]
      else
        params[:reservation][:status_id] = Status[:approved]
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
    relation = Reservation
    relation = relation.with_deleted if current_user.admin?
    @reservation = relation.find(params[:id])

    @del_or_clear = @reservation.deleted_at ? 'Delete' : 'Clear'

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end

    respond_to do |format|
      reservation = @reservation
      destroyed = @reservation.destroy
      format.html do
        if destroyed
          flash[:notice] = "#{@del_or_clear.sub(/e$/, '')}ed reservation #{reservation.id}"
          if request.referer.match(/#{reservation.id}$/)
            redirect_to ('/')
          else
            redirect_to :back
          end
        else
          flash[:error] = "Could not #{@del_or_clear.downcase} reservation #{reservation.id}"
          redirect_to :back
        end
      end
      format.js do
        if not destroyed
          render :js => "alert('Deletion of Reservation #{@reservation.id} failed');"
        end
      end
    end
  end

  def update
    relation = Reservation
    relation = relation.with_deleted if current_user.admin?
    @reservation = relation.find(params[:id])

    unless current_user.admin? || @reservation.user_id == current_user.id
       redirect_to('/') and return
    end

    params[:reservation][:reservable_asset] = @reservation.reservable_asset

    current_user.admin? ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status_id] = Status[:pending]
      else
        params[:reservation][:status_id] = Status[:approved]
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

  def approve
    relation = Reservation
    relation = relation.with_deleted if current_user.admin?
    @reservation = relation.find(params[:id])

    @reservation.status_id = Status[:approved]
    @reservation.save

    respond_to do |format|
      format.js
    end
  end
end
