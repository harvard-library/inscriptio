class Reservation < ActiveRecord::Base
  belongs_to :reservable_asset
  belongs_to :user
  
  def to_s
    %Q|#{id}|
  end
end
