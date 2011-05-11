class ReservableAsset < ActiveRecord::Base
  belongs_to :floor
  belongs_to :reservable_asset_type
  has_many :reservations
  has_many :users, :through => :reservations
  has_one :bulletin_board
  
end
