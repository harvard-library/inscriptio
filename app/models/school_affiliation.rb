class SchoolAffiliation < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name
  
  def to_s
    %Q|#{name}|
  end
end
