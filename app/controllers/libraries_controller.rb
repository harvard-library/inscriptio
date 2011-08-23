class LibrariesController < ApplicationController
  before_filter :authenticate_admin!, :only => [:new, :create, :edit, :update, :destroy]

  def index
    @libraries = Library.all
    @assets = ReservableAssetType.all
    @welcome_message = Message.find(:first, :conditions => ["title LIKE ?", '%Welcome%'])
    if @welcome_message.nil?
      @message = Message.new
    end    
  end

  def new
    @library = Library.new
  end

  def create
    @library = Library.new
    @library.attributes = params[:library]
    respond_to do|format|
      if @library.save
        flash[:notice] = 'Added that library'
        format.html { render :action => :show }
      else 
        flash[:error] = 'Could not create that library'
        format.html { render :action => :new }
      end
    end
  end

  def edit
    @library = Library.find(params[:id])
  end

  def update
    @library = Library.find(params[:id])
    @library.attributes = params[:library]
    respond_to do|format|
      if @library.save
        flash[:notice] = %Q|#{@library} updated|
        format.html {render :action => :show}
      else
        flash[:error] = 'Could not update that library'
        format.html {render :action => :new}
      end
    end
  end

  def show
    @library = Library.find(params[:id])
    @subject_areas = []
    @library.floors.collect{|f| @subject_areas << f.subject_areas}
    @subject_areas.flatten!
    
    breadcrumbs.add @library.name, @library.id
  end

  def destroy
    @library = Library.find(params[:id])
    library_name = @library.name
    if @library.destroy
      flash[:notice] = %Q|Deleted #{library_name}|
      redirect_to :action => :index
    end
  end

end
