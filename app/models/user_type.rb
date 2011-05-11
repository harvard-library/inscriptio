class UserType < ActiveRecord::Base
  has_many :users
  has_many :authentication_sources
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
