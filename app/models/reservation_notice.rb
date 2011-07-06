class ReservationNotice < ActiveRecord::Base
  belongs_to :reservable_asset_type
  belongs_to :status
  
  validates_presence_of :subject, :message, :reply_to
end
