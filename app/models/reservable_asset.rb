class ReservableAsset < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  mount_uploader :photo, AssetPhotoUploader

  belongs_to :floor

  belongs_to :reservable_asset_type
  delegate :user_types, :to => :reservable_asset_type
  delegate :library, :to => :reservable_asset_type

  has_many :reservations, :dependent => :destroy
  has_many :users, :through => :reservations
  has_one :bulletin_board, :dependent => :destroy

  validates_presence_of :floor_id, :name
  validates_presence_of :reservable_asset_type_id
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  validates_format_of :slots, :with => /\A[A-Z]+(,[A-Z]+)*\Z/, :message => "must be in the format of 'A,B,C'", :if => Proc.new {|this| this.slots != ""}

  def to_s
    %Q|#{name}|
  end

  def max_concurrent_users
    if (!read_attribute(:max_concurrent_users).blank? && !read_attribute(:max_concurrent_users).nil?) || self.reservable_asset_type.nil?
      read_attribute(:max_concurrent_users)
    else
      self.reservable_asset_type.max_concurrent_users
    end
  end

  def min_reservation_time
    if (!read_attribute(:min_reservation_time).blank? && !read_attribute(:min_reservation_time).nil?) || self.reservable_asset_type.nil?
      read_attribute(:min_reservation_time)
    else
      self.reservable_asset_type.min_reservation_time
    end
  end

  def max_reservation_time
    if (!read_attribute(:max_reservation_time).blank? && !read_attribute(:max_reservation_time).nil?) || self.reservable_asset_type.nil?
      read_attribute(:max_reservation_time)
    else
      self.reservable_asset_type.max_reservation_time
    end
  end

  def slots
    if (!read_attribute(:slots).blank? && !read_attribute(:slots).nil?) || self.reservable_asset_type.nil?
      read_attribute(:slots)
    else
      self.reservable_asset_type.slots
    end
  end

  def current_users
    self.users.includes(:reservations).where('reservations.end_date > current_date').where('reservations.status_id IN (?)', Status::ACTIVE_IDS)
  end

  def current_reservations
    self.reservations.where('reservations.end_date > current_date').status(Status::ACTIVE_IDS)
  end

  def reservations_pending
    self.reservations.where('reservations.end_date > current_date').where('reservations.status_id = ?', Status[:pending])
  end

  def reservations_declined
    self.reservations.where('reservations.end_date > current_date').where('reservations.status_id = ?', Status[:declined])
  end

  def reservations_approved
    self.reservations.where('reservations.end_date > current_date').where('reservations.status_id = ?', Status[:approved])
  end

  def reservations_waitlist
    self.reservations.where('reservations.end_date > current_date').where('reservations.status_id = ?', Status[:waitlist])
  end

  def reservations_recently_expired
    year = Date.today.prev_month.month == 12 ? Date.today.prev_year.year : Date.today.year
    self.reservations.where('reservations.status_id = ?', Status[:expired]).where('EXTRACT(month from reservations.end_date) = ? and EXTRACT(year from reservations.end_date) = ?', Date.today.prev_month.month, year)
  end

  def slots_equal_users?
    (self.slots.split(',').length == self.max_concurrent_users) || (self.max_concurrent_users == 1 && self.slots.nil?)
  end

  def full?
    self.current_users.length >= self.max_concurrent_users
  end

  def self.search(search)
    if search
      where("lower(name) LIKE ?", "%#{search}%")
    end
  end
end
