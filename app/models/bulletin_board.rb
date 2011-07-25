class BulletinBoard < ActiveRecord::Base
  has_many :posts, :dependent => :destroy, :order => :created_at
  has_many :users, :through => :posts
  belongs_to :reservable_asset
  
end
