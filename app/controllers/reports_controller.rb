class ReportsController < ApplicationController
  
  def index
    @libraries = Library.all
    @assets = ReservableAsset.all
  end
  
end
