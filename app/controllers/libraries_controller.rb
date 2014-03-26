class LibrariesController < ApplicationController
  load_and_authorize_resource :except => [:index]
  before_filter :add_breadcrumbs, :only => [:edit, :show] # MUST be after load_and_authorize_resource

  def index
    authorize! :read, Library
    @libraries = Library.all
    @welcome_message = Message.find(:first, :conditions => ["title LIKE ?", '%Welcome%'])
    if @welcome_message.nil?
      @message = Message.new
    end
  end

  def create
    @library.attributes = params[:library]
    respond_to do|format|
      if @library.save
        flash.now[:notice] = 'Added that library'
        format.html { render :action => :show }
      else
        flash.now[:error] = 'Could not create that library'
        format.html { render :action => :new }
      end
    end
  end

  def update
    @library.attributes = params[:library]
    respond_to do|format|
      if @library.save
        flash.now[:notice] = %Q|#{@library} updated|
        format.html {render :action => :show}
      else
        flash.now[:error] = 'Could not update that library'
        format.html {render :action => :new}
      end
    end
  end

  def add_breadcrumbs
    breadcrumbs.add @library.name, @library.id
  end

  def destroy
    library_name = @library.name
    if @library.destroy
      flash[:notice] = %Q|Deleted #{library_name}|
      redirect_to :action => :index
    end
  end

end
