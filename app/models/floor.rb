class Floor < ActiveRecord::Base
  acts_as_list :scope => :library
  belongs_to :library

end
