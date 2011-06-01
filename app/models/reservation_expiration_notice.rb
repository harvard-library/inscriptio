class ReservationExpirationNotice < ActiveRecord::Base
  belongs_to :reservable_asset_type
  has_many :reservations
  
  validates_presence_of :subject, :message, :reply_to
  validates_uniqueness_of :notice_type
  
  NOTICE_TYPE = ['Hold', 'Actual']
end
