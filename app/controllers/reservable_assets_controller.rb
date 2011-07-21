require 'fastercsv'
class ReservableAssetsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @reservable_assets = ReservableAsset.all
    @libraries = Library.all
  end

  def new
    @reservable_asset = ReservableAsset.new
    @library = Library.find(params[:library])
  end

  def show
    @reservable_asset = ReservableAsset.find(params[:id])
    
    breadcrumbs.add @reservable_asset.floor.library.name, library_path(@reservable_asset.floor.library.id)
    breadcrumbs.add @reservable_asset.floor.name, library_floor_path(@reservable_asset.floor.library.id,@reservable_asset.floor.id)
    breadcrumbs.add @reservable_asset.name, @reservable_asset.id
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
  
  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    FasterCSV.parse(@file.read).each do |cell|

        floor = Floor.find(cell[0].to_i)
        asset_type = ReservableAssetType.find(cell[1].to_i)
        
        asset={}
        
        asset[:floor] = floor
        asset[:reservable_asset_type] = asset_type
        asset[:name] = cell[2]
        asset[:description] = cell[3]
        asset[:location] = cell[4]
        asset[:min_reservation_time] = cell[5]
        asset[:max_reservation_time] = cell[6]
        asset[:max_concurrent_users] = cell[7]
        asset[:access_code] = cell[9]
        asset[:notes] = cell[10]
        
        @reservable_asset = ReservableAsset.new

        #setting the attributes from the associated reservable asset type if not specified for the reservable asset
        if asset[:min_reservation_time].blank? || asset[:min_reservation_time].nil?
          asset[:min_reservation_time] = ReservableAssetType.find(asset_type).min_reservation_time
        end
        if asset[:max_reservation_time].blank? || asset[:max_reservation_time].nil?
          asset[:max_reservation_time] = ReservableAssetType.find(asset_type).max_reservation_time
        end
        if asset[:max_concurrent_users].blank? || asset[:max_concurrent_users].nil?
          asset[:max_concurrent_users] = ReservableAssetType.find(asset_type).max_concurrent_users
        end  
        @reservable_asset.attributes = asset
    
        if @reservable_asset.save
          if @reservable_asset.reservable_asset_type.has_bulletin_board
            @bulletin_board = BulletinBoard.new
            @bulletin_board.reservable_asset = @reservable_asset
            @bulletin_board.post_lifetime = "1 month"
            @bulletin_board.save!
          end
        end
    end
    redirect_to reservable_asset_types_path
  end  
  
  def available
    @reservable_asset_types = ReservableAssetType.all
    @libraries = Library.all
  end  
end
