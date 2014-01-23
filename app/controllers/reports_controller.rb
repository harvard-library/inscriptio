class ReportsController < ApplicationController
  require 'csv'
  before_filter :authenticate_admin!

  def index
    @actions = self.action_methods.reject {|am| am == 'index'}
    breadcrumbs.add 'Reports'
  end

  def active_carrels
    begin
      start_horizon = !params[:active_carrels][:start_horizon].blank? ? Date.strptime(params[:active_carrels][:start_horizon], "%m/%d/%Y") : nil
      end_horizon = !params[:active_carrels][:end_horizon].blank? ? Date.strptime(params[:active_carrels][:end_horizon], "%m/%d/%Y") : nil
    rescue ArgumentError => e
      flash[:error] = "Please make sure your dates are valid, and take the form M/D/Y"
      redirect_to :back
      return
    end

    result = Report.active_carrels(start_horizon, end_horizon)
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
