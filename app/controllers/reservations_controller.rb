class ReservationsController < ApplicationController
  before_filter :verify_credentials, :only => [:index, :new, :show, :create, :update, :destroy]
  before_filter :process_dates, :only => [:create, :update]
  load_resource :only => [:new, :create, :expire]

  def process_dates
    params[:reservation][:start_date] = Date.strptime(params[:reservation][:start_date], "%m/%d/%Y")
    params[:reservation][:end_date] = Date.strptime(params[:reservation][:end_date], "%m/%d/%Y")
  end

  def index
    authorize! :manage, Reservation
    if current_user.admin?
      rel = Library
    else
      rel = current_user.local_admin_permissions
    end
    rel = rel.includes(:reservable_asset_types => {:reservable_assets => {:reservations => :user}})
    rel = rel.where("reservations.status_id IN (?)", Status[:pending, :expired, :approved, :expiring, :renewal_confirmation])
    rel = rel.where('reservations.deleted_at IS NULL')
    @libraries = rel.order('libraries.id, reservable_asset_types.id, users.email').references(:reservations)

    # The output of the following nested reduce is a nested hash of arrays of Reservations,
    # keyed by [:library_id][:reservable_asset_type_id][:status_name]
    @reservations = @libraries.reduce({}) do |libs, l|
      libs[l.id] = l.reservable_asset_types.reduce({}) do |rats, rat|
        rats[rat.id] = rat.reservable_assets.reduce({}) do |ras, ra|
          ra.reservations.each do |r|
            case r.status_id
            when Status[:pending]
              ras['Pending'] ? ras['Pending'].push(r) : (ras['Pending'] = [r])
            when Status[:renewal_confirmation]
              ras['Renewal'] ? ras['Renewal'].push(r) : (ras['Renewal'] = [r])
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
    @reservable_asset = ReservableAsset.find(params[:reservable_asset])
    @reservation.reservable_asset = @reservable_asset
    authorize! :reserve, @reservable_asset
    @max_time = @reservable_asset.max_reservation_time
    @min_time = @reservable_asset.min_reservation_time
  end

  def show
    relation = Reservation
    relation = relation.with_deleted if can? :manage, Reservation
    @reservation = relation.find(params[:id])
    authorize! :show, @reservation
    if @reservation.deleted_at
      flash.now[:notice] = "DELETED AT #{@reservation.deleted_at}"
      @del_or_clear = 'Delete'
    else
      @del_or_clear = 'Clear'
    end

    @authority = {
      :edit =>    can?(:edit, @reservation),
      :expire =>  can?(:expire, @reservation),
      :destroy => can?(:destroy, @reservation)}
  end

  def edit
    relation = Reservation
    relation = relation.with_deleted if can? :manage, Reservation
    @reservation = relation.find(params[:id])

    authorize! :update, @reservation

    flash.now[:notice] = "DELETED AT #{@reservation.deleted_at}" if @reservation.deleted_at

    @reservable_asset = @reservation.reservable_asset
    @max_time = @reservable_asset.max_reservation_time
    @min_time = @reservable_asset.min_reservation_time
    unless params[:renew].nil?
      @renew = true
    end
  end

  def create
    params[:reservation][:reservable_asset] = defined?(@reservable_asset) ? @reservable_asset : ReservableAsset.find(params[:reservation][:reservable_asset_id])

    can?(:manage, Reservation) ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user.id)
    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status_id] = Status[:pending]
      else
        params[:reservation][:status_id] = Status[:approved]
      end
    end

    @reservation.attributes = reservation_params
    authorize! :create, @reservation
    @reservation.slot = @reservation.assign_slot
    respond_to do |format|
      if @reservation.save
        flash[:notice] = 'Added that Reservation'
        format.html { redirect_to @reservation }
      else
        flash.now[:error] = "Reservation could not be saved."
        @reservable_asset = @reservation.reservable_asset
        format.html{ render :action => :new }
      end
    end
  end

  def destroy
    relation = Reservation
    relation = relation.with_deleted if can? :manage, Reservation
    @reservation = relation.find(params[:id])

    @del_or_clear = @reservation.deleted_at ? 'Delete' : 'Clear'

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
    relation = relation.with_deleted if can? :manage, Reservation
    @reservation = relation.find(params[:id])

    params[:reservation][:reservable_asset] = @reservation.reservable_asset

    can?(:manage, Reservation) ? params[:reservation][:user] = User.find(params[:reservation][:user_id]) : params[:reservation][:user] = User.find(current_user)

    if params[:reservation][:status_id].nil? || params[:reservation][:status_id].blank?
      if params[:reservation][:reservable_asset].reservable_asset_type.require_moderation
        params[:reservation][:status_id] = Status[:pending]
      else
        params[:reservation][:status_id] = Status[:approved]
      end
    end
    @reservation.attributes = reservation_params
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
    relation = relation.with_deleted if can? :manage, Reservation

    @reservation = relation.find(params[:id])
    authorize! :update, @reservation

    @reservation.status_id = Status[:approved]
    @reservation.save

    respond_to do |format|
      format.js
    end
  end

  def expire
    authorize! :expire, @reservation
    if @reservation.status_id == Status[:pending]
      success = @reservation.destroy
    else
      success = @reservation.update_column(:status_id, Status[:expired])
    end
    respond_to do |format|
      if success
        format.js { @reservation }
        format.html {
          if can? :manage, @reservation.library
            redirect_to @reservation
          else
            redirect_to reservations_user_url(@reservation.user)
          end
        }
      else
        format.js { head :status => 500 }
      end
    end
  end

  def renew
    @reservation = Reservation.find(params[:id])
    authorize! :renew, @reservation
    if @reservation.reservable_asset_type.require_moderation
      new_status_id = Status[:renewal_confirmation]
    else
      new_status_id = Status[:approved]
    end
    attrs = @reservation.attributes.except(
              *%w(id
                  start_date
                  end_date
                  status_id
                  deleted_at
                  created_at
                  updated_at)).merge(
                                     :start_date => Date.today,
                                     :end_date => Date.today + @reservation.reservable_asset_type.max_reservation_time.days,
                                     :status_id => new_status_id)
    @new_res = Reservation.new(attrs)

    @reservation.update_attribute(:deleted_at, Time.now)

    success = @new_res.save
    unless success
      @reservation.restore
    end

    respond_to do |format|
      format.js do
        if success
          @new_res
        else
         head :status => 500
        end
      end
      format.html do
        unless success
          flash[:base] = "Couldn't renew reservation"
        end
        if can? :manage, @reservation.library
          redirect_to (success ? @new_res : @reservation)
        else
          redirect_to reservations_user_url(@new_res.user)
        end
      end
    end
  end
  private
  def reservation_params
    r_params = params.require(:reservation).permit( :reservable_asset_id, :reservable_asset, :user_id, :user, :status_id,
                                         :start_date, :end_date, :tos, :slot)
    r_params[:user] = params[:reservation][:user]
    r_params[:reservable_asset] = params[:reservation][:reservable_asset]
    r_params
  end
end
