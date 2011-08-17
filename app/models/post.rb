class Post < ActiveRecord::Base
  belongs_to :bulletin_board
  belongs_to :user
  has_many :moderator_flags
  
  validates_presence_of :message
  
  after_create :post_save_hooks
  
  def post_save_hooks
    self.bulletin_board.users.each do |user|
      Email.create(
        :to => user.email,
        :subject => "There\'s a New Post to Your Bulletin Board",
        :body => "A new bulletin board post was created for #{@bulletin_board.reservable_asset.reservable_asset_type.name} #{@bulletin_board.reservable_asset.name}"
      )
    end  
  end
end
