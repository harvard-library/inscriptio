class Reservation < ActiveRecord::Base
  belongs_to :reservable_asset
  belongs_to :user
  
  validates_presence_of :user, :reservable_asset
  
  def to_s
    %Q|#{id}|
  end
  
  def allow_edit?(current_user)
    self.user_id == current_user.id
  end
  
  def date_valid?(start_date, end_date)
    time_in_days = (end_date - start_date).to_i
    if time_in_days > 0 && time_in_days >= self.reservable_asset.min_reservation_time.to_i && time_in_days <= self.reservable_asset.max_reservation_time.to_i
      true
    else
      false
    end    
  end  
end
