class ModeratorFlag < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  
  validates_presence_of :reason
end
