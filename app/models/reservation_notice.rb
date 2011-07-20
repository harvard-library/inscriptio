class ReservationNotice < ActiveRecord::Base
  belongs_to :reservable_asset_type
  belongs_to :status
  belongs_to :library
  belongs_to :reservable_asset_type
  
  validates_presence_of :subject, :message
end
