class ReportsController < ApplicationController
  
  def index
    @libraries = Library.all
    @assets = ReservableAsset.all
    
    breadcrumbs.add 'Reports'
  end
  
end
