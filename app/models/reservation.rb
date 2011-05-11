class Reservation < ActiveRecord::Base
  belongs_to :reservable_asset
  belongs_to :user
  
  validates_presence_of :code
  validates_uniqueness_of :code
end
