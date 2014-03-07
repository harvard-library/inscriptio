class SchoolAffiliation < ActiveRecord::Base
  attr_accessible :name

  has_many :user

  validates_presence_of :name

  def to_s
    %Q|#{name}|
  end
end
