class StatusesController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]
  
  def index
    @statuses = Status.all
  end

  def new
    @status = Status.new
  end

  def show
    @status = Status.find(params[:id])
  end

  def edit
    @status = Status.find(params[:id])
  end
  
  def create
    @status = Status.new
    @status.attributes = params[:status]
    respond_to do|format|
      if @status.save
        flash[:notice] = 'Added that Status'
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not add that Status'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @status = Status.find(params[:id])
    status = @status.name
    if @status.destroy
      flash[:notice] = %Q|Deleted user type #{status}|
      redirect_to :action => :index
    end
  end

  def update
    @status = Status.find(params[:id])
    @status.attributes = params[:status]
    respond_to do|format|
      if @status.save
        flash[:notice] = %Q|#{@status} updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not update that Status'
        format.html {render :action => :new}
      end
    end
  end
end
