class ApplicationController < ActionController::Base
  before_filter :verify_credentials
  protect_from_forgery
  
  private 
  def verify_credentials
    user_signed_in? || admin_signed_in?  
  end 
end
