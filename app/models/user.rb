class User < ActiveRecord::Base
  belongs_to :user_type
  has_many :reservations
  has_many :reservable_assets, :through => :reservations
  has_many :posts
  has_one :authentication_source, :through => :user_type
  
end
