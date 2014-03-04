class SubjectAreasController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]

  def index
    @libraries = Library.includes(:subject_areas)
    if params[:library_id]
      @libraries = @libraries.where(:id => params[:library_id])
    end
    breadcrumbs.add "Subject Areas"
  end

  def new
    @subject_area = SubjectArea.new
    @subject_area.library_id = params[:library_id]
  end

  def show
    @subject_area = SubjectArea.find(params[:id])
    breadcrumbs.add @subject_area.library.name, library_path(@subject_area.library)
    breadcrumbs.add @subject_area.name, @subject_area.id
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
        format.html {redirect_to library_subject_areas_path(@subject_area.library, @subject_area)}
      else
        flash.now[:error] = 'Could not add that Subject Area'
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
    end
  end

  def update
    @subject_area = SubjectArea.find(params[:id])
    @subject_area.attributes = params[:subject_area].except(:library_id).merge(:library_id => @subject_area.library_id)
    respond_to do|format|
      if @subject_area.save
        flash[:notice] = %Q|#{@subject_area} updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not update that Subject Area'
        format.html {render :action => :new}
      end
    end
  end

end
