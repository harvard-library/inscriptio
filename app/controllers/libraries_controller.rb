class LibrariesController < ApplicationController

  def new
    @library = Library.new
  end

  def create
    @library = Library.new
    @library.attributes = params[:library]
    respond_to do|format|
      if @library.save
        flash[:notice] = 'Added that Library'
        format.html { render :action => :show }
      else 
        flash[:error] = 'Could not add that Library'
        format.html { render :action => :new }
      end
    end
  end

  def show
    @library = Library.find(params[:id])
  end
end
