class Reservation < ActiveRecord::Base
  belongs_to :reservable_asset
  belongs_to :user
  
  def to_s
    %Q|#{id}|
  end
  
  def allow_edit?(current_user)
    self.user_id == current_user.id
  end
  
  def date_diff(start_date, end_date)
    p "date difference in days"
    p (end_date - start_date).to_i
    (end_date - start_date).to_i
  end  
end
