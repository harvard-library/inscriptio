class ReservableAssetType < ActiveRecord::Base
  belongs_to :library
  has_many :reservable_assets
  has_many :reservation_expiration_notices
  has_many :user_types
  
  validates_presence_of :name, :library_id
  
  def to_s
    %Q|#{name}|
  end
end
