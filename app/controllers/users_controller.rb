class UsersController < ApplicationController
  require 'csv'
  before_filter :fetch_statuses, :only => [:show, :reservations]
  before_filter :fetch_permitted_libraries, :only => [:new, :edit]
  load_and_authorize_resource :except => [:import, :export, :create]
  before_filter :process_special_params, :only => [:create, :update]

  def fetch_statuses
    @statuses = Status.to_hash.select {|k| %w(Pending Expired Approved).include? k}
  end

  def fetch_permitted_libraries
    @libraries = current_user.admin? ? Library.all : current_user.local_admin_permissions
  end

  def process_special_params
    # These fields are handled specially
    excluded = [:admin, :password, :user_type_ids, :local_admin_permission_ids]

    if !@user
      @user = User.new(params[:user].except(*excluded))
    end

    my_types = params[:user][:user_type_ids].try {|t| t.reject(&:blank?).map(&:to_i)} || []
    my_perms = params[:user][:local_admin_permission_ids].try {|p| p.reject(&:blank?).map(&:to_i)} || []

    # Local admins can't remove or add other libraries' types
    unless current_user.admin?
      can_permit = current_user.local_admin_permission_ids

      # remove that which admin shalt not touch
      my_types = my_types - UserType.where('library_id NOT IN (?)', can_permit).pluck(:id)
      my_perms = my_perms - Library.where('id NOT IN (?)', can_permit).pluck(:id)

      # add that which admin may not remove
      my_types = my_types + @user.user_types.where('library_id NOT IN (?)', can_permit).pluck(:id)
      my_perms = my_perms + @user.local_admin_permissions.where('id NOT IN (?)', can_permit).pluck(:id)

    end

    # Set mass assigned attributes
    @user.attributes = params[:user].except(*excluded)

    # Special handling
    @user.user_type_ids = my_types if my_types
    @user.local_admin_permission_ids = my_perms if my_perms

    if current_user.admin? && params[:user][:admin]
      params[:user][:admin] == "1" ? @user.admin = true : @user.admin = false
    end

    if action_name == 'create'
      @user.password = params[:user][:password].blank? ? User.random_password : params[:user][:password]
    elsif params[:user][:password] && !params[:user][:password].blank?
      @user.password = params[:user][:password]
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
    authorize! :create, @user
    respond_to do|format|
      if @user.save
        flash[:notice] = "Added #{@user.email}"
        format.html {redirect_to :action => :index}
      else
        flash[:error] = "Could not add #{@user.email}"
        format.html {redirect_to :action => :new}
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
        format.html {redirect_to :back}
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
