class ReservationNotice < ActiveRecord::Base
  attr_accessible :library, :library_id, :reservable_asset_type, :reservable_asset_type_id, :status,:status_id, :subject, :message, :reply_to

  belongs_to :reservable_asset_type
  belongs_to :status
  belongs_to :library
  belongs_to :reservable_asset_type

  validates_presence_of :subject, :message
end
