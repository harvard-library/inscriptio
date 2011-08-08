class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  before_filter :add_initial_breadcrumbs
  
  protect_from_forgery
  
  private 
  def authenticate_admin!
    current_user.admin?  
  end
    
  def verify_credentials
    user_signed_in?
  end

  def add_initial_breadcrumbs
    breadcrumbs.add 'Home', root_path
  end 
  
  
end
