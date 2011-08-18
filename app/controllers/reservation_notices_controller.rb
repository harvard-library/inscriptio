class ReservationNoticesController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @reservation_notices = ReservationNotice.all
    @libraries = Library.all
    
    breadcrumbs.add "Reservation Notices"
  end

  def new
    @reservation_notice = ReservationNotice.new
  end

  def show
    @reservation_notice = ReservationNotice.find(params[:id])
  end

  def edit
    @reservation_notice = ReservationNotice.find(params[:id])
  end
  
  def create
    @reservation_notice = ReservationNotice.new
    @reservation_notice.attributes = params[:reservation_notice]
    respond_to do|format|
      if @reservation_notice.save
        flash[:notice] = 'Added that Reservation Notice'
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not add that Reservation Notice'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservation_notice = ReservationNotice.find(params[:id])
    reservation_notice = @reservation_notice.type
    if @reservation_notice.destroy
      flash[:notice] = %Q|Deleted Reservation Notice #{reservation_notice}|
      redirect_to :action => :index
    end
  end

  def update
    @reservation_notice = ReservationNotice.find(params[:id])
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
  
  def generate_notices
    asset_type = ReservableAssetType.find(params[:asset_type])
    ReservationNotice.destroy_all(:reservable_asset_type_id => asset_type.id)
    statuses = Status.all
    
    statuses.each do |s|
      notice = ReservationNotice.new(:library => asset_type.library, :reservable_asset_type => asset_type, :status => s, :subject => s.name, :message => s.name)
      notice.save
      puts "Successfully created #{notice.subject}"
    end    
    redirect_to reservation_notices_path
  end  
end
