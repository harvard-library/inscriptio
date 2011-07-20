class ReservationNoticesController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @reservation_notices = ReservationNotice.all
    @libraries = Library.all
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
    else

    end
  end

  def update
    @reservation_notice = ReservationNotice.find(params[:id])
    @reservation_notice.attributes = params[:reservation_notice]
    respond_to do|format|
      if @reservation_notice.save
        flash[:notice] = %Q|#{@reservation_notice} updated|
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not update that Reservation Notice'
        format.html {render :action => :new}
      end
    end
  end
  
  def generate_notices
    ReservationNotice.destroy_all
    assets = ReservableAssetType.all
    statuses = Status.all
    
    assets.each do |a|
      statuses.each do |s|
        notice = ReservationNotice.new(:library => a.library, :reservable_asset_type => a, :status => s, :subject => s.name, :message => s.name)
        notice.save
        puts "Successfully created #{notice.subject}"
      end    
    end
    redirect_to reservation_notices_path
  end  
end
