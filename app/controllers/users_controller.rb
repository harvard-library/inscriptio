class UsersController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @users = User.all
    
    breadcrumbs.add 'Users'
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @reservations = Reservation.find(:all, :conditions => {:user_id => @user.id}, :order => ['created_at DESC'])
    
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new
    @user.attributes = params[:user]
    respond_to do|format|
      if @user.save
        flash[:notice] = 'Added that User'
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not add that User'
        format.html {render :action => :new}
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    user = @user.email
    if @user.destroy
      flash[:notice] = %Q|Deleted user #{user}|
      redirect_to :action => :index
    else

    end
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = params[:user]
    params[:user][:admin] == "1" ? @user.admin = true : @user.admin = false  
    respond_to do|format|
      if @user.save
        flash[:notice] = %Q|#{@user} updated|
        format.html {redirect_to :action => :index}
      else
        flash[:error] = 'Could not update that User'
        format.html {render :action => :new}
      end
    end
  end
end
