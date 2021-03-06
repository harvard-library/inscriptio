class LibrariesController < ApplicationController
  load_and_authorize_resource :except => [:index]
  before_filter :add_breadcrumbs, :only => [:edit, :show] # MUST be after load_and_authorize_resource

  def index
    authorize! :read, Library
    @libraries = Library.all
    @welcome_message = Message.where("title LIKE '%Welcome%'").first
    if @welcome_message.nil?
      @message = Message.new
    end
  end

  def create
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
    @library.attributes = library_params
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
  private
  def library_params
    params.require(:library).permit( :name, :url, :address_1, :address_2,
                   :city, :state, :zip, :latitude, :longitude,
                   :contact_info, :description, :tos, :bcc,:from)
  end
end
