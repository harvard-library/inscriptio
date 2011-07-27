class CallNumbersController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]

  def index
    @call_numbers = CallNumber.all
    
    breadcrumbs.add "Call Numbers"
  end

  def new
    @call_number = CallNumber.new
  end

  def show
    @call_number = CallNumber.find(params[:id])
    
    breadcrumbs.add @call_number.subject_area.name, subject_area_path(@call_number.subject_area.id)
    breadcrumbs.add @call_number.call_number, @call_number.id
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

  def destroy
    @call_number = CallNumber.find(params[:id])
    call_number = @call_number.call_number
    if @call_number.destroy
      flash[:notice] = %Q|Deleted call number #{call_number}|
      redirect_to :action => :index
    else

    end
  end

  def edit
    @call_number = CallNumber.find(params[:id])
  end

  def update
    @call_number = CallNumber.find(params[:id])
    @call_number.attributes = params[:call_number]
    respond_to do|format|
      if @call_number.save
        flash[:notice] = %Q|#{@call_number} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that Call Number'
        format.html {render :action => :new}
      end
    end
  end

end
