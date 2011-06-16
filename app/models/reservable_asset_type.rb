class ReservableAssetType < ActiveRecord::Base
  mount_uploader :photo, AssetTypePhotoUploader
  
  belongs_to :library
  has_many :reservable_assets
  has_many :reservation_expiration_notices
  has_and_belongs_to_many :user_types
  
  validates_presence_of :name, :library_id
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :reservation_time_increment, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :expiration_extension_time, :only_integer => true, :message => "can only be whole number."
  
  def to_s
    %Q|#{name}|
  end
end
