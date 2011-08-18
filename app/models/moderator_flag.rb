class ModeratorFlag < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :reason
  
  after_create :post_save_hooks
  
  def post_save_hooks
    Email.create(
      :from => self.post.bulletin_board.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.post.bulletin_board.reservable_asset.reservable_asset_type.library.from,
      :to => self.post.user.email,
      :bcc => self.post.bulletin_board.reservable_asset.reservable_asset_type.library.bcc,
      :subject => "There\'s a Flag on Your Bulletin Board Post",
      :body => "A moderator flag has been put on your bulletin board post for #{self.post.bulletin_board.reservable_asset.reservable_asset_type.name} #{self.post.bulletin_board.reservable_asset.name}."
    )  
  end
end
