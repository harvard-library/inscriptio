class Library < ActiveRecord::Base
  has_many :floors, :dependent => :destroy, :order => :position
  has_many :reservable_asset_types

  validates_presence_of :name, :address_1, :city, :state, :zip
  validates_format_of :url, :with => /^https?:\/\//, :allow_blank => true
  validates_length_of :description, :contact_info, :maximum => 16.kilobytes, :allow_blank => true

  def to_s
    %Q|#{name}|
  end
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end
end
