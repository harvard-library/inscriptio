class BulletinBoard < ActiveRecord::Base
  attr_accessible

  has_many :posts, :dependent => :destroy, :order => :created_at
  has_many :users, :through => :posts
  belongs_to :reservable_asset

  def self.prune_posts
    BulletinBoard.all.each do |bb|
      unless bb.posts.nil?
        bb.posts.each do |post|
          post.destroy if Date.today - post.created_at.to_date >= bb.post_lifetime
        end
      end
    end
  end

end
