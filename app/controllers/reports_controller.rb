class ReportsController < ApplicationController
  require 'csv'

  # The structure here is REPORTS[:action] = {:header => "...", :description => "..."}
  # Used in this controller for building actions and in the view for display.
  REPORTS = {
    :active_assets => {
      :header => "Active Assets Per Library",
      :description => "This report shows the number of reservable assets which were active in the libraries (optionally between a starting date and ending date). This will reflect any reservations that are active during any days between the start date and end date, inclusive. Assets are counted as active if they have any occupied slots."
    },
    :user_types => {
      :header => "Asset Reservations per User Type, Library",
      :description => " This report shows the number of users of each type that have assets reserved in each library (optionally between a starting and ending date, inclusive).",
    }
  }

  before_action :process_horizons, :only => REPORTS.keys

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
    authorize! :manage, Report
    @reports = REPORTS
    breadcrumbs.add 'Reports'
  end

  # Build each action from REPORTS
  REPORTS.keys.each do |report|
    define_method(report) do
      authorize! :manage, Report
      result = Report.send(report, @start_horizon, @end_horizon)
      respond_to do |format|
        format.csv do
          csv = CSV.generate(:encoding => 'utf-8') do |csv|
            result.each do |el|
              csv << el
            end
          end
          render :plain => csv
        end
      end
    end
  end
end
