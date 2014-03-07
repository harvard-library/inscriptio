class ReservableAssetType < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  attr_accessible( :library_id, :user_type_ids,
                   :name,
                   :min_reservation_time, :max_reservation_time, :expiration_extension_time,
                   :max_concurrent_users,
                   :has_code, :has_bulletin_board, :require_moderation,
                   :welcome_message,
                   :photo,
                   :slots )

  mount_uploader :photo, AssetTypePhotoUploader

  belongs_to :library
  has_many :reservable_assets, :order => :name, :dependent => :destroy
  has_and_belongs_to_many :user_types
  has_many :reservation_notices

  validates_presence_of :name, :library_id, :min_reservation_time, :max_reservation_time, :max_concurrent_users, :expiration_extension_time
  validates_numericality_of :min_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_reservation_time, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :max_concurrent_users, :only_integer => true, :message => "can only be whole number."
  validates_numericality_of :expiration_extension_time, :only_integer => true, :message => "can only be whole number."
  validates_format_of :slots, :with => /\A[A-Z]+(,[A-Z]+)*\Z/, :message => "must be in the format of 'A,B,C'", :if => Proc.new {|this| this.slots != ""}

  after_create :generate_notices

  def generate_notices
    ReservationNotice.regenerate_notices(self)
  end

  def to_s
    %Q|#{name}|
  end

  def slots_equal_users?
    (self.slots.split(',').length == self.max_concurrent_users) || (self.max_concurrent_users == 1 && (self.slots.nil? || self.slots.blank?))
  end

end
