class Library < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  attr_accessible( :name, :url,
                   :address_1, :address_2,
                   :city, :state, :zip,
                   :latitude, :longitude,
                   :contact_info,
                   :description,
                   :tos,
                   :bcc,:from,
                   :floor_ids, :reservable_asset_type_ids, :reservation_notice_ids)

  has_many :floors, :dependent => :destroy, :order => :position
  has_many :user_types, :dependent => :destroy
  has_many :reservable_asset_types, :dependent => :destroy
  has_many :reservation_notices, :dependent => :destroy
  has_many :subject_areas, :dependent => :destroy
  has_many :call_numbers, :through => :subject_areas
  has_and_belongs_to_many( :local_admins,
                           :class_name => "User",
                           :join_table => :libraries_users_admin_permissions)

  validates_presence_of :name, :address_1, :city, :state, :zip, :from
  validates_format_of :url, :with => /\Ahttps?:\/\//, :allow_blank => true
  validates_format_of :from, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :bcc, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true
  validates_length_of :description, :contact_info, :maximum => 16.kilobytes, :allow_blank => true

  def to_s
    %Q|#{name}|
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end

  def bcc_list
    self.bcc.split(',')
  end
end
