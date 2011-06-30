class Status < ActiveRecord::Base
  has_many :reservations
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_s
    %Q|#{name}|
  end
end
