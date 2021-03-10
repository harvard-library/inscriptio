class BulletinBoard < ApplicationRecord
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)

  has_many :posts, -> { order "created_at" }, :dependent => :destroy
  has_many :users, :through => :posts
  belongs_to :reservable_asset
  delegate :library, :to => :reservable_asset

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
