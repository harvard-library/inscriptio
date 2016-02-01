require 'csv'
class ReservableAssetsController < ApplicationController
  load_and_authorize_resource :reservable_asset_type, :only => [:new, :create]
  load_and_authorize_resource :except => [:new, :create]
  load_and_authorize_resource :through => :reservable_asset_type, :only => [:new, :create]

  def index
    @libraries = Library.all
  end

  def show
    breadcrumbs.add @reservable_asset.floor.library.name, library_path(@reservable_asset.floor.library.id)
    breadcrumbs.add @reservable_asset.floor.name, library_floor_path(@reservable_asset.floor.library.id,@reservable_asset.floor.id)
    breadcrumbs.add @reservable_asset.name, @reservable_asset.id
  end

  def create
    respond_to do|format|

      if @reservable_asset.slots_equal_users?
        if @reservable_asset.save
          if @reservable_asset.reservable_asset_type.has_bulletin_board
            @bulletin_board = BulletinBoard.new
            @bulletin_board.reservable_asset = @reservable_asset
            @bulletin_board.post_lifetime = 30
            @bulletin_board.save!
          end
          flash.now[:notice] = 'Added that Reservable Asset'
          format.html {render :action => :show}
        else
          flash.now[:error] = 'Could not add that Reservable Asset'
          format.html {render :action => :new}
        end
      else
        flash.now[:error] = 'Number of slots does not match number of concurrent users.'
        format.html {render :action => :new}
      end

    end
  end

  def destroy
    reservable_asset = @reservable_asset.id
    if @reservable_asset.destroy
      respond_to do |format|
        format.html do
          flash[:notice] = %Q|Deleted reservable asset #{reservable_asset}|
          redirect_to reservable_asset_types_url
        end
        format.js
      end
    end
  end

  def update
    @reservable_asset.attributes = reservable_asset_params
    respond_to do|format|

      if @reservable_asset.slots_equal_users?
        if @reservable_asset.save
          flash.now[:notice] = %Q|#{@reservable_asset} updated|
          format.html {render :action => :show}
        else
          flash.now[:error] = 'Could not update that Reservable Asset'
          format.html {render :action => :new}
        end
      else
        flash.now[:error] = 'Number of slots does not match number of concurrent users.'
        format.html {render :action => :new}
      end

    end
  end

  def locate
    @reservable_asset.x1 = params[:reservable_asset][:x1]
    @reservable_asset.y1 = params[:reservable_asset][:y1]
    @reservable_asset.x2 = params[:reservable_asset][:x2]
    @reservable_asset.y2 = params[:reservable_asset][:y2]
    respond_to do|format|
      if @reservable_asset.save
        flash.now[:notice] = %Q|#{@reservable_asset} updated|
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not update that Reservable Asset'
        format.html {render :action => :new}
      end
    end
  end

  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    CSV.parse(@file.read).each do |cell|
      @reservable_asset = ReservableAsset.new
      @reservable_asset.floor = Floor.find(cell[0].to_i)
      @reservable_asset.attributes = %w|name
                                        description
                                        location
                                        min_reservation_time
                                        max_reservation_time
                                        max_concurrent_users
                                        slots
                                        access_code notes|.zip(cell[2..10]).to_h
      # Protected assets here
      @reservable_asset.reservable_asset_type = ReservableAssetType.find(cell[1].to_i)
      @reservable_asset.name = cell[2],

      if @reservable_asset.save
        if @reservable_asset.reservable_asset_type.has_bulletin_board
          @bulletin_board = BulletinBoard.new
          @bulletin_board.reservable_asset = @reservable_asset
          @bulletin_board.post_lifetime = 30
          @bulletin_board.save!
        end
      end
    end
    redirect_to reservable_asset_types_path
  end
  private
  def reservable_asset_params
    params.require(:reservable_asset).permit( :floor_id, :reservable_asset_type_id,
                   :name, :description, :location, :access_code, :notes,
                   :x1, :x2, :y1, :y2,:min_reservation_time, :max_reservation_time, :expiration_extension_time,
                   :max_concurrent_users,:has_code, :has_bulletin_board, :require_moderation,
                   :welcome_message,:photo,:slots )
  end
end
