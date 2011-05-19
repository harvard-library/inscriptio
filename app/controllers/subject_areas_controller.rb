class SubjectAreasController < ApplicationController
  before_filter :authenticate_admin!, :except => [:new, :create, :edit, :update, :destroy]
  
  def index
    @subject_areas = SubjectArea.all
  end

  def new
    @subject_area = SubjectArea.new
  end

  def show
    @subject_area = SubjectArea.find(params[:id])
  end

  def edit
    @subject_area = SubjectArea.find(params[:id])
  end
  
  def create
    @subject_area = SubjectArea.new
    @subject_area.attributes = params[:subject_area]
    respond_to do|format|
      if @subject_area.save
        flash[:notice] = 'Added that Subject Area'
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not add that Subject Area'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @subject_area = SubjectArea.find(params[:id])
    subject_area = @subject_area.name
    if @subject_area.destroy
      flash[:notice] = %Q|Deleted subject area #{subject_area}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @subject_area = SubjectArea.find(params[:id])
    @subject_area.attributes = params[:subject_area]
    respond_to do|format|
      if @subject_area.save
        flash[:notice] = %Q|#{@subject_area} updated|
        format.html {render :action => :index}
      else
        flash[:error] = 'Could not update that Subject Area'
        format.html {render :action => :new}
      end
    end
  end

end
