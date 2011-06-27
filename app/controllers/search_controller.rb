class SearchController < ApplicationController
  
  def index
    @libraries = Library.search(params[:search].downcase)
    @floors = Floor.search(params[:search].downcase)
    @subject_areas = SubjectArea.search(params[:search].downcase)
    @call_numbers = CallNumber.search(params[:search].downcase)
    @reservable_assets = ReservableAsset.search(params[:search].downcase)
  end  
end
