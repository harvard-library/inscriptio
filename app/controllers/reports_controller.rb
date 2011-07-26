class ReportsController < ApplicationController
  
  def index
    @libraries = Library.all
    @assets = ReservableAsset.all
    @reservable_asset_types = ReservableAssetType.all
    
    breadcrumbs.add 'Reports'
  end
  
end
