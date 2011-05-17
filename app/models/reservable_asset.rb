class ReservableAsset < ActiveRecord::Base
  mount_uploader :photo, AssetPhotoUploader
  
  belongs_to :floor
  belongs_to :reservable_asset_type
  has_many :reservations
  has_many :users, :through => :reservations
  has_one :bulletin_board
  
  validates_presence_of :floor_id
  validates_presence_of :reservable_asset_type_id
  
  scope :current_users, joins(:reservations).where('reservations.end_date > current_date()')
  
end
