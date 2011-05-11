class Post < ActiveRecord::Base
  belongs_to :bulletin_board
  belongs_to :user
  has_many :moderator_flags
  
  validates_presence_of :message
end
