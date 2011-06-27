class ReservableAsset < ActiveRecord::Base
  mount_uploader :photo, AssetPhotoUploader
  
  belongs_to :floor
  belongs_to :reservable_asset_type
  has_many :reservations
  has_many :users, :through => :reservations
  has_one :bulletin_board
  
  validates_presence_of :floor_id
  validates_presence_of :reservable_asset_type_id
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :reservation_time_increment, :only_integer => true, :message => "can only be whole number."
  
  def to_s
    %Q|#{id}|
  end
  
  def current_users
    self.users.where('reservations.end_date > current_date')
  end  
  
  def allow_reservation?(current_user)
    !self.current_users.include?(current_user) && self.max_concurrent_users > self.current_users.length
  end  
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end
end
