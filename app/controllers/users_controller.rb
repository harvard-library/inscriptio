class UsersController < ApplicationController
  require 'csv'
  before_filter :authenticate_admin!, :except => [:edit, :update, :reservations]
  before_filter :fetch_statuses, :only => [:show, :reservations]

  def fetch_statuses
    @statuses = Status.to_hash.select {|k| %w(Pending Expired Approved).include? k}
  end

  def index
    @users = User.find(:all, :order => ['created_at ASC'])
    breadcrumbs.add 'Users'
    @csv = params[:csv]
  end

  def new
    @user = User.new

    breadcrumbs.add 'Users', users_path
    breadcrumbs.add 'New'
  end

  def create
    @user = User.new
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
    @user = User.find(params[:id])
    @reservations = @user.reservations.order('created_at DESC')

    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
  end

  def edit
    @user = User.find(params[:id])

    unless current_user.admin? || @user.email == current_user.email
       redirect_to('/') and return
    end

    breadcrumbs.add 'Users', users_path
    breadcrumbs.add @user.email, @user.id
    breadcrumbs.add 'Edit'
  end

  def destroy
    @user = User.find(params[:id])

    unless current_user.admin? || @user.email == current_user.email
       redirect_to('/') and return
    end

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
    @user = User.find(params[:id])

    unless current_user.admin? || @user.email == current_user.email
       redirect_to('/') and return
    end

    @user.attributes = params[:user].except(:admin,:password)

    if params[:user][:admin]
      params[:user][:admin] == "1" ? @user.admin = true : @user.admin = false
    end

    if params[:user][:password] && !params[:user][:password].blank?
      @user.password = params[:user][:password]
    end

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
    @user = User.find(params[:id])

    @reservations = @user.reservations.status(Status::ACTIVE_IDS).group_by {|r| r.status.name}
  end

end
