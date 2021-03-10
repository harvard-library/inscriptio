class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :add_initial_breadcrumbs

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |e|
    redirect_to root_url, :alert => e.message
  end

  private
  def authenticate_admin!
    if !(current_user.admin? || current_user.local_admin_permissions.count > 0)
      redirect_to(root_url)
    end

  end

  def verify_credentials
    user_signed_in? || redirect_to(root_url)
  end

  def add_initial_breadcrumbs
    breadcrumbs.add 'Home', root_path
  end

end
