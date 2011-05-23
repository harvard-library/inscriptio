class ReservableAssetTypesController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @reservable_asset_types = ReservableAssetType.all
  end

  def new
    @reservable_asset_type = ReservableAssetType.new
  end

  def show
    @reservable_asset_type = ReservableAssetType.find(params[:id])
  end

  def edit
    @reservable_asset_type = ReservableAssetType.find(params[:id])
  end
  
  def create
    @reservable_asset_type = ReservableAssetType.new
    @reservable_asset_type.attributes = params[:reservable_asset_type]
    respond_to do|format|
      if @reservable_asset_type.save
        flash[:notice] = 'Added that Reservable Asset Type'
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not add that Reservable Asset Type'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @reservable_asset_type = ReservableAssetType.find(params[:id])
    reservable_asset_type = @reservable_asset_type.name
    if @reservable_asset_type.destroy
      flash[:notice] = %Q|Deleted reservable asset type #{reservable_asset_type}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @reservable_asset_type = ReservableAssetType.find(params[:id])
    @reservable_asset_type.attributes = params[:reservable_asset_type]
    respond_to do|format|
      if @reservable_asset_type.save
        flash[:notice] = %Q|#{@reservable_asset_type} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Reservable Asset Type'
        format.html {render :action => :new}
      end
    end
  end
end
