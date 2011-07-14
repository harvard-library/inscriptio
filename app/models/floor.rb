class Floor < ActiveRecord::Base

  mount_uploader :floor_map, FloorMapUploader
  acts_as_list :scope => :library
  belongs_to :library
  has_and_belongs_to_many :call_numbers, :order => :call_number
  has_and_belongs_to_many :subject_areas, :order => :name
  has_many :reservable_assets, :order => :name, :dependent => :destroy

  validates_presence_of :name, :library_id, :floor_map

  def to_s
    %Q|#{name}|
  end
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ?', "%#{search}%"])
    end
  end

end
