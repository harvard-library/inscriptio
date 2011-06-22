class ReservableAssetsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @reservable_assets = ReservableAsset.all
  end

  def new
    @reservable_asset = ReservableAsset.new
  end

  def show
    @reservable_asset = ReservableAsset.find(params[:id])
  end

  def edit
    @reservable_asset = ReservableAsset.find(params[:id])
  end
  
  def create
    @reservable_asset = ReservableAsset.new
    
    #setting the attributes from the associated reservable asset type if not specified for the reservable asset
    if params[:reservable_asset][:min_reservation_time].blank? || params[:reservable_asset][:min_reservation_time].nil?
      params[:reservable_asset][:min_reservation_time] = ReservableAssetType.find(params[:reservable_asset][:reservable_asset_type_id]).min_reservation_time
    end
    if params[:reservable_asset][:max_reservation_time].blank? || params[:reservable_asset][:max_reservation_time].nil?
      params[:reservable_asset][:max_reservation_time] = ReservableAssetType.find(params[:reservable_asset][:reservable_asset_type_id]).max_reservation_time
    end
    if params[:reservable_asset][:max_concurrent_users].blank? || params[:reservable_asset][:max_concurrent_users].nil?
      params[:reservable_asset][:max_concurrent_users] = ReservableAssetType.find(params[:reservable_asset][:reservable_asset_type_id]).max_concurrent_users
    end
    if params[:reservable_asset][:reservation_time_increment].blank? || params[:reservable_asset][:reservation_time_increment].nil?
      params[:reservable_asset][:reservation_time_increment] = ReservableAssetType.find(params[:reservable_asset][:reservable_asset_type_id]).reservation_time_increment
    end  
    @reservable_asset.attributes = params[:reservable_asset]
    respond_to do|format|
      if @reservable_asset.save
        if @reservable_asset.reservable_asset_type.has_bulletin_board
          @bulletin_board = BulletinBoard.new
          @bulletin_board.reservable_asset = @reservable_asset
          @bulletin_board.post_lifetime = "1 month"
          @bulletin_board.save!
        end  
        flash[:notice] = 'Added that Reservable Asset'
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not add that Reservable Asset'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservable_asset = ReservableAsset.find(params[:id])
    reservable_asset = @reservable_asset.id
    if @reservable_asset.destroy
      flash[:notice] = %Q|Deleted reservable asset #{reservable_asset}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @reservable_asset = ReservableAsset.find(params[:id])
    @reservable_asset.attributes = params[:reservable_asset]
    respond_to do|format|
      if @reservable_asset.save
        flash[:notice] = %Q|#{@reservable_asset} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Reservable Asset'
        format.html {render :action => :new}
      end
    end
  end

  def locate
    @reservable_asset = ReservableAsset.find(params[:id])
    @reservable_asset.x1 = params[:reservable_asset][:x1]
    @reservable_asset.y1 = params[:reservable_asset][:y1]
    @reservable_asset.x2 = params[:reservable_asset][:x2]
    @reservable_asset.y2 = params[:reservable_asset][:y2]
    respond_to do|format|
      if @reservable_asset.save
        flash[:notice] = %Q|#{@reservable_asset} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Reservable Asset'
        format.html {render :action => :new}
      end
    end
  end
end
