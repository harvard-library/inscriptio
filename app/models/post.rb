class Post < ApplicationRecord
#  attr_accessible :bulletin_board_id, :bulletin_board, :user_id, :user, :message, :media

  belongs_to :bulletin_board
  belongs_to :user
  delegate :library, :to => :bulletin_board
  has_many :moderator_flags, :dependent => :destroy

  validates_presence_of :message, :user

  after_create :post_save_hooks

  def post_save_hooks
    self.bulletin_board.reservable_asset.users.each do |user|
      Email.create(
        :from => self.bulletin_board.reservable_asset.reservable_asset_type.library.from,
        :reply_to => self.bulletin_board.reservable_asset.reservable_asset_type.library.from,
        :to => user.email,
        :subject => "There\'s a New Post to Your Bulletin Board",
        :body => "A new bulletin board post was created for #{self.bulletin_board.reservable_asset.reservable_asset_type.name} #{self.bulletin_board.reservable_asset.name}."
      )
    end
  end

end
