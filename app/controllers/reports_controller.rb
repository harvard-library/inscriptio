class ReportsController < ApplicationController
  require 'csv'

  REPORTS = {
    :active_assets => {
      :header => "Active Assets Per Library",
      :description => "This report shows the number of reservable assets which were active in the libraries (optionally between a starting date and ending date). This will reflect any reservations that are active during any days between the start date and end date. Also note that any slots aren't taken into account - partial occupancy is identical to full occupancy."
    },
    :user_types => {
      :header => "Carrel Reservations per User Type, Library",
      :description => " This report shows the number of users of each type that have carrels reserved in each library (optionally between a starting and ending date).",
    }
  }

  before_filter :authenticate_admin!
  before_filter :process_horizons, :only => REPORTS.keys

  def process_horizons
    begin
      @start_horizon = !params[params[:action]][:start_horizon].blank? ? Date.strptime(params[params[:action]][:start_horizon], "%m/%d/%Y") : nil
      @end_horizon = !params[params[:action]][:end_horizon].blank? ? Date.strptime(params[params[:action]][:end_horizon], "%m/%d/%Y") : nil
    rescue ArgumentError => e
      flash[:error] = "Please make sure your dates are valid, and take the form M/D/Y"
      redirect_to :back
      return
    end
  end

  def index
    @reports = REPORTS

    breadcrumbs.add 'Reports'
  end

  REPORTS.keys.each do |report|
    define_method(report) do
      result = Report.send(report, @start_horizon, @end_horizon)
      respond_to do |format|
        format.csv do
          csv = CSV.generate(:encoding => 'utf-8') do |csv|
            result.each do |el|
              csv << el
            end
          end
          render :text => csv
        end
      end
    end
  end
end
