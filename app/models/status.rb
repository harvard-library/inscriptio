class Status < ActiveRecord::Base
  attr_accessible :name

  has_many :reservations
  has_one :reservation_notice

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    %Q|#{name}|
  end
end
