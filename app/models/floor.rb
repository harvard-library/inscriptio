class Floor < ActiveRecord::Base

  mount_uploader :floor_map, FloorMapUploader
  acts_as_list :scope => :library
  belongs_to :library
  has_and_belongs_to_many :call_numbers, :order => :call_number
  has_many :subject_areas

  validates_presence_of :name, :library_id, :floor_map

  def to_s
    %Q|#{name}|
  end

end
