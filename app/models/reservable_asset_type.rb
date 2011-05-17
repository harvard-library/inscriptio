class ReservableAssetType < ActiveRecord::Base
  mount_uploader :photo, AssetTypePhotoUploader
  
  belongs_to :library
  has_many :reservable_assets
  has_many :reservation_expiration_notices
  has_and_belongs_to_many :user_types
  
  validates_presence_of :name, :library_id
  
  def to_s
    %Q|#{name}|
  end
end
