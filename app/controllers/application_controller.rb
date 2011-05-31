class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  
  private 
  def authenticate_admin!
    current_user.admin?  
  end
    
  def verify_credentials
    user_signed_in?
  end 
end
