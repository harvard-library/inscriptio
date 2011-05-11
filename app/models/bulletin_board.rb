class BulletinBoard < ActiveRecord::Base
  has_many :posts, :order => :creation_time
  has_many :users
  belongs_to :reservable_asset
  
end
