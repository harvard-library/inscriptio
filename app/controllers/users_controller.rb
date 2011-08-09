class UsersController < ApplicationController
  before_filter :authenticate_admin!
  
  def index
    @users = User.find(:all, :order => ['created_at ASC'])
    
    breadcrumbs.add 'Users'
  end

  def new
    @user = User.new
    
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add 'New'
  end

  def show
    @user = User.find(params[:id])
    @reservations = Reservation.find(:all, :conditions => {:user_id => @user.id}, :order => ['created_at DESC'])
    
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
  end

  def edit
    @user = User.find(params[:id])
    
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
    breadcrumbs.add 'Edit'
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
  
  def import
    @file = params[:upload][:datafile] unless params[:upload].blank?
    FasterCSV.parse(@file.read).each do |cell|
      @user = User.new  
      user_type = UserType.find(cell[0].to_i)
      school_affiliation = SchoolAffiliation.find(cell[1].to_i)
      p "school affiliation--------------------------------------"
      p school_affiliation
      p user_type
        
      #user={}
        
      @user.user_type_id = user_type.id
      @user.school_affiliation_id = school_affiliation.id
      @user.email = cell[2]
      @user.password = cell[3]
      @user.first_name = cell[4]
      @user.last_name = cell[5]
        
      #@user.attributes = user
      @user.save
    end
    redirect_to users_path
  end

end
