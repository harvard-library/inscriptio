class CallNumbersController < ApplicationController
  load_and_authorize_resource :except => [:new, :index]
  load_resource :call_number, :only => [:new]

  def index
    @libraries = Library.accessible_by(current_ability).includes(:call_numbers)
    @libraries = @libraries.where(:id => params[:library_id]) if params[:library_id]
    @libraries = @libraries.where(:subject_areas => {:id => params[:subject_area_id]}) if params[:subject_area_id]

    breadcrumbs.add "Call Numbers"
  end

  def new
    @call_number.library = Library.find(params[:library_id].to_i)
    authorize! :create, @call_number
    @call_number.subject_area = SubjectArea.find(params[:subject_area_id]) if params[:subject_area_id]

    breadcrumbs.add 'Call Numbers', call_numbers_path
    breadcrumbs.add 'New'
  end

  def show
    if @call_number.subject_area
      breadcrumbs.add @call_number.subject_area.name, subject_area_path(@call_number.subject_area)
    end
    breadcrumbs.add @call_number.call_number, @call_number.id
  end

  def create
    @call_number.library = Library.find(params[:library_id])
    respond_to do|format|
      if @call_number.save
        flash[:notice] = 'Added that Call Number'
        format.html {redirect_to :action => :index }
      else
        flash.now[:error] = 'Could not add that Call Number'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    call_number = @call_number.call_number
    if @call_number.destroy
      flash[:notice] = %Q|Deleted call number #{call_number}|
      redirect_to :action => :index
    end
  end

  def edit
    breadcrumbs.add 'Call Numbers', call_numbers_path
    breadcrumbs.add 'Edit'
  end

  def update
    @call_number.attributes = params[:call_number]
    respond_to do|format|
      if @call_number.save
        flash.now[:notice] = %Q|#{@call_number} updated|
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not update that Call Number'
        format.html {render :action => :new}
      end
    end
  end

end
