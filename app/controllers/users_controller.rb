class UsersController < ApplicationController
  require 'csv'
  before_filter :fetch_statuses, :only => [:show, :reservations]
  before_filter :fetch_permitted_libraries, :only => [:new, :edit]
  load_and_authorize_resource :except => [:import, :export]

  def fetch_statuses
    @statuses = Status.to_hash.select {|k| %w(Pending Expired Approved).include? k}
  end

  def fetch_permitted_libraries
    if current_user.admin?
      @libraries = Library.all
    else
      @libraries = current_user.local_admin_permissions
    end
  end

  def index
    @users = @users.order('created_at ASC')
    breadcrumbs.add 'Users'
    @csv = params[:csv]
  end

  def new
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add 'New'
  end

  def create
    @user.attributes = params[:user].except(:admin, :password)

    @user.password = params[:user][:password].blank? ? User.random_password : params[:user][:password]

    if params[:user][:admin]
      params[:user][:admin] == "1" ? @user.admin = true : @user.admin = false
    end

    respond_to do|format|
      if @user.save
        flash[:notice] = "Added #{@user.email}"
        format.html {redirect_to :action => :index}
      else
        flash[:error] = "Could not add #{@user.email}"
        format.html {render :action => :new}
      end
    end
  end

  def show
    @reservations = @user.reservations.order('created_at DESC')

    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
  end

  def edit
    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
    breadcrumbs.add 'Edit'
  end

  def destroy
    user = @user.email
    respond_to do |format|

      if @user.destroy
        format.html do
          flash[:notice] = %Q|Deleted user #{user}|
          redirect_to :action => :index
        end
        format.js
      else
        flash[:notice] = %Q|Failed to delete user #{user}|
        redirect_to :action => :index
      end
    end
  end

  def update
    excluded = [:admin, :password]
    excluded << :user_type_ids unless can? :all_but_destroy, User

    unless current_user.admin?
      params[:user][:user_type_ids] =
        params[:user][:user_type_ids] + @user.user_types.where('library_id NOT IN (?)', current_user.local_admin_permissions.pluck(:id)).pluck(:id)
    end

    @user.attributes = params[:user].except(*excluded)

    if current_user.admin? && params[:user][:admin]
      params[:user][:admin] == "1" ? @user.admin = true : @user.admin = false
    end

    if params[:user][:password] && !params[:user][:password].blank?
      @user.password = params[:user][:password]
    end

    respond_to do|format|
      if @user.save
        flash[:notice] = %Q|#{@user} updated|
        if can? :all_but_destroy, @user
          format.html {redirect_to :action => :index}
        else
          format.html {redirect_to :root}
        end
      else
        flash[:error] = 'Could not update that User'
        format.html {render :action => :new}
      end
    end
  end

  def import
    authorize! :all_but_destroy, User
    @file = params[:upload][:datafile] unless params[:upload].blank?
    CSV.parse(@file.read).each do |cell|
      @user = User.new
      @user.user_types = UserType.find(cell[0].split(/[\s+,;]/).map(&:to_i))
      school_affiliation = SchoolAffiliation.find(cell[1].to_i)

      @user.school_affiliation_id = school_affiliation.id
      @user.email = cell[2]
      @user.password = User.random_password
      @user.first_name = cell[3]
      @user.last_name = cell[4]

      @user.save!
    end
    redirect_to users_path
  end

  def export
    authorize! :all_but_destroy, User
    @users = User.find(:all, :order => ['email ASC'])
    CSV.open("#{Rails.root}/public/uploads/users.csv", "w") do |csv|
      @users.each do |user|
        csv << [user.user_type_ids.join(' '), user.school_affiliation.try(:id) , user.email, user.first_name, user.last_name]
      end
    end
    @csv = true
    flash[:notice] = 'Exported!'
    redirect_to users_path(:csv => @csv)
  end

  def reservations
    @reservations = @user.reservations.status(Status::ACTIVE_IDS).group_by {|r| r.status.name}
  end

end
