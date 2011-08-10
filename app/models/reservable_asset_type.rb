class ReservableAssetType < ActiveRecord::Base
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
  validates_format_of :slots, :with => /^[A-Z]+(,[A-Z]+)*$/, :message => "must be in the format of 'A,B,C'", :if => Proc.new {|this| this.slots != ""}
  
  def to_s
    %Q|#{name}|
  end
  
  def slots_equal_users?
    (self.slots.split(',').length == self.max_concurrent_users) || (self.max_concurrent_users == 1 && (self.slots.nil? || self.slots.blank?))
  end  
  
end
