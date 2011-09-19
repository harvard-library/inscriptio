class Reservation < ActiveRecord::Base
  belongs_to :reservable_asset
  belongs_to :user
  belongs_to :status
  
  validates_presence_of :user, :reservable_asset
  
  after_save :post_save_hooks
  after_destroy :post_destroy_hooks
  
  def post_save_hooks
    notice = ReservationNotice.find(:first, :conditions => {:status_id => self.status_id, :reservable_asset_type_id => self.reservable_asset.reservable_asset_type.id, :library_id => self.reservable_asset.reservable_asset_type.library.id})
    Email.create(
      :from => self.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.reservable_asset.reservable_asset_type.library.from,
      :to => self.user.email,
      :bcc => self.reservable_asset.reservable_asset_type.library.bcc,
      :subject => notice.subject,
      :body => notice.message
    )
      
  end
  
  def post_destroy_hooks
    notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'cancelled'"]), :reservable_asset_type_id => self.reservable_asset.reservable_asset_type.id, :library_id => self.reservable_asset.reservable_asset_type.library.id})
    Email.create(
      :from => self.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.reservable_asset.reservable_asset_type.library.from,
      :to => self.user.email,
      :bcc => self.reservable_asset.reservable_asset_type.library.bcc,
      :subject => notice.subject + " " + self.reservable_asset.name,
      :body => notice.message
    )  
  end
  
  def to_s
    %Q|#{id}|
  end
  
  def allow_edit?(current_user)
    self.user_id == current_user.id && self.pending?
  end
  
  def date_valid?(start_date, end_date)
    time_in_days = (end_date - start_date).to_i
    if time_in_days > 0 && time_in_days >= self.reservable_asset.min_reservation_time.to_i && time_in_days <= self.reservable_asset.max_reservation_time.to_i
      true
    else
      false
    end    
  end  
  
  def assign_slot
    slots = self.reservable_asset.slots.split(",")
    used_slots = []
    self.reservable_asset.current_reservations.collect{|s| used_slots << s.slot}
    available_slots = slots - used_slots
    unless available_slots.nil?
      available_slots.first
    end  
  end  
  
  def pending?
    pending = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    self.status == pending
  end
  
  def declined?
    declined = Status.find(:first, :conditions => ["lower(name) = 'declined'"])
    self.status == declined
  end
  
  def approved?
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    self.status == approved
  end
  
  def expiring?
    Reservation.find(:all, :conditions => ['status_id = ? AND end_date - current_date <= ?', Status.find(:first, :conditions => ["lower(name) = 'approved'"]), self.reservable_asset.reservable_asset_type.expiration_extension_time.to_i]).include?(self)
  end
end
