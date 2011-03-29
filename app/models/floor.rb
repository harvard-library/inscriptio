class Floor < ActiveRecord::Base

  mount_uploader :floor_map, FloorMapUploader
  acts_as_list :scope => :library
  belongs_to :library

  validates_presence_of :name

end
