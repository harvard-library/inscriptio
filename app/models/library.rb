class Library < ActiveRecord::Base
  validates_presence_of :name
  has_many :floors, :dependent => :destroy

end
