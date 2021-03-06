class Floor < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)

  mount_uploader :floor_map, FloorMapUploader
  acts_as_list :scope => :library
  belongs_to :library
  has_and_belongs_to_many :call_numbers, -> { order "call_number" }
  has_many :subject_areas, -> { order "name" }, :through => :call_numbers
  has_many :reservable_assets,  -> { order "name" }, :dependent => :destroy

  validates_presence_of :name, :library_id, :floor_map

  def to_s
    %Q|#{name}|
  end

  def self.search(search)
    if search
      where("lower(name) LIKE ?", "%#{search}%")
    end
  end

end
