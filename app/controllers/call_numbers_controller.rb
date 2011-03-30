class CallNumbersController < ApplicationController
  def new
    @call_number = CallNumber.new
  end

  def create
    @call_number = CallNumber.new
    @call_number.attributes = params[:call_number]
    respond_to do|format|
      if @call_number.save
        flash[:notice] = 'Added that Call Number'
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not add that Call Number'
        format.html {render :action => :new}
      end
    end
  end

end
