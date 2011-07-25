class ReservableAsset < ActiveRecord::Base
  mount_uploader :photo, AssetPhotoUploader
  
  belongs_to :floor
  belongs_to :reservable_asset_type
  has_many :reservations, :dependent => :destroy
  has_many :users, :through => :reservations
  has_one :bulletin_board, :dependent => :destroy
  
  validates_presence_of :floor_id
  validates_presence_of :reservable_asset_type_id
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  
  def to_s
    %Q|#{id}|
  end
  
  def current_users
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    self.users.where('reservations.end_date > current_date') && self.users.where('reservations.status_id = ?', approved)
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
  
  def asset_full?
    self.current_users.length >= self.max_concurrent_users
  end
  
  def allow_reservation?(current_user)
    all_current = ReservableAsset.all.collect{|r| r.current_users}.flatten
    current_user_reservation = Reservation.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'approved'"]).id, :user_id => current_user.id})
    
    if current_user.admin || current_user_reservation.nil?
      true  
    elsif all_current.include?(current_user) && current_user_reservation.expiring?
      if self.max_concurrent_users > self.current_users.length
        if self.reservable_asset_type.user_types.include?(current_user.user_type)
          true
        else
          p "not the right user type"
          false  
        end
      else
        p "asset is full"
        false    
      end  
    else
      p "is not admin or has no current reservations"
      false    
    end
  end  
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end  
end