class UserTypesController < ApplicationController
  load_and_authorize_resource :except => [:index]

  def index
    authorize! :manage, Library
    @libraries = Library.includes(:user_types)
    breadcrumbs.add 'User Types'
  end

  def new
    @user_type.library = Library.find(params[:library_id])
  end

  def show
    breadcrumbs.add 'User Types', user_types_path
    breadcrumbs.add @user_type.name, @user_type.id
  end

  def edit
  end

  def create
    respond_to do|format|
      if @user_type.save
        flash[:notice] = "Added #{@user_type} to #{@user_type.library.name}"
        format.html {redirect_to :action => :index}
      else
        flash[:error] = "Could not add #{@user_type} to #{@user_type.library}"
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    user_type = @user_type.name
    if @user_type.destroy
      flash[:notice] = %Q|Deleted #{user_type} from #{@user_type.library}|
      redirect_to :action => :index
    end
  end

  def update
    respond_to do|format|
      if @user_type.save
        flash[:notice] = %Q|#{@user_type} (at #{@user_type.library}) updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = "Could not update #{@user_type} (at #{@user_type.library})"
        format.html {render :action => :new}
      end
    end
  end
end
