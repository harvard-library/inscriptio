class AuthenticationSource < ActiveRecord::Base
  has_many :users
  has_many :user_types
  
end
