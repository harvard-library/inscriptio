class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery
  
  private 
  def verify_credentials
    user_signed_in?
  end 
end
