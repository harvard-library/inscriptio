class UserTypesController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]

  def index
    @libraries = Library.includes(:user_types)

    breadcrumbs.add 'User Types'
  end

  def new
    @user_type = UserType.new
    @user_type.library = Library.find(params[:library_id])
  end

  def show
    @user_type = UserType.find(params[:id])

    breadcrumbs.add 'User Types', user_types_path
    breadcrumbs.add @user_type.name, @user_type.id
  end

  def edit
    @user_type = UserType.find(params[:id])
  end

  def create
    @user_type = UserType.new
    @user_type.attributes = params[:user_type]
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
    @user_type = UserType.find(params[:id])
    user_type = @user_type.name
    if @user_type.destroy
      flash[:notice] = %Q|Deleted #{user_type} from #{@user_type.library}|
      redirect_to :action => :index
    end
  end

  def update
    @user_type = UserType.find(params[:id])
    @user_type.attributes = params[:user_type]
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
