class ReservableAsset < ActiveRecord::Base
  mount_uploader :photo, AssetPhotoUploader
  
  belongs_to :floor
  belongs_to :reservable_asset_type
  has_many :reservations, :dependent => :destroy
  has_many :users, :through => :reservations
  has_one :bulletin_board, :dependent => :destroy
  
  validates_presence_of :floor_id, :name
  validates_presence_of :reservable_asset_type_id
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  validates_format_of :slots, :with => /^[A-Z]+(,[A-Z]+)*$/, :message => "must be in the format of 'A,B,C'", :if => Proc.new {|this| this.slots != ""}
  
  def to_s
    %Q|#{name}|
  end
  
  def max_concurrent_users
    if (!read_attribute(:max_concurrent_users).blank? && !read_attribute(:max_concurrent_users).nil?) || self.reservable_asset_type.nil?
      read_attribute(:max_concurrent_users)
    else
      ReservableAssetType.find(self.reservable_asset_type).max_concurrent_users
    end    
  end
  
  def min_reservation_time
    if (!read_attribute(:min_reservation_time).blank? && !read_attribute(:min_reservation_time).nil?) || self.reservable_asset_type.nil?
      read_attribute(:min_reservation_time)
    else
      ReservableAssetType.find(self.reservable_asset_type).min_reservation_time
    end    
  end
  
  def max_reservation_time
    if (!read_attribute(:max_reservation_time).blank? && !read_attribute(:max_reservation_time).nil?) || self.reservable_asset_type.nil?
      read_attribute(:max_reservation_time)
    else
      ReservableAssetType.find(self.reservable_asset_type).max_reservation_time
    end    
  end
  
  def slots
    if (!read_attribute(:slots).blank? && !read_attribute(:slots).nil?) || self.reservable_asset_type.nil?
      read_attribute(:slots)
    else
      ReservableAssetType.find(self.reservable_asset_type).slots
    end    
  end
  
  def current_users
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    pending = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    self.users.where('reservations.end_date > current_date') && self.users.where('reservations.status_id = ? or reservations.status_id = ?', approved, pending)
  end
  
  def current_reservations
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    pending = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    self.reservations.where('reservations.end_date > current_date') && self.reservations.where('reservations.status_id = ? or reservations.status_id = ?', approved, pending)
  end   
  
  def reservations_pending
    pending = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    self.reservations.where('reservations.end_date > current_date') && self.reservations.where('reservations.status_id = ?', pending)
  end
  
  def reservations_declined
    declined = Status.find(:first, :conditions => ["lower(name) = 'declined'"])
    self.reservations.where('reservations.end_date > current_date') && self.reservations.where('reservations.status_id = ?', declined)
  end
  
  def reservations_approved
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    self.reservations.where('reservations.end_date > current_date') && self.reservations.where('reservations.status_id = ?', approved)
  end 
  
  def reservations_waitlist
    waitlist = Status.find(:first, :conditions => ["lower(name) = 'waitlist'"])
    self.reservations.where('reservations.end_date > current_date') && self.reservations.where('reservations.status_id = ?', waitlist)
  end
  
  def reservations_recently_expired
    expired = Status.find(:first, :conditions => ["lower(name) = 'expired'"])
    year = Date.today.prev_month.month == 12 ? Date.today.prev_year.year : Date.today.year
    self.reservations.where('reservations.status_id = ?', expired) && self.reservations.where('EXTRACT(month from reservations.end_date) = ? and EXTRACT(year from reservations.end_date) = ?', Date.today.prev_month.month, year)
  end
  
  def slots_equal_users?
    (self.slots.split(',').length == self.max_concurrent_users) || (self.max_concurrent_users == 1 && self.slots.nil?)
  end
  
  def asset_full?
    self.current_users.length >= self.max_concurrent_users
  end
  
  def allow_reservation?(current_user)
    all_current = ReservableAsset.all.collect{|r| r.current_users}.flatten
    current_user_reservation = Reservation.find(:first, :conditions => ["status_id in (?) and user_id = ?", Status.find(:all, :conditions => ["lower(name) = 'approved' or lower(name) = 'pending'"]).collect{|s| s.id}, current_user.id])
    if current_user.admin
      true
    elsif self.max_concurrent_users > self.current_users.length && self.reservable_asset_type.user_types.include?(current_user.user_type)
      if current_user_reservation.nil?
        true
      elsif all_current.include?(current_user) && current_user_reservation.expiring?
        true
      else
        p "has a current reservation and not current expiring"
        false  
      end
    else
      p "not admin or asset is full or not the right user type"
      false        
    end
  end  
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end  
end