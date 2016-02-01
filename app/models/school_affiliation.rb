class SchoolAffiliation < ActiveRecord::Base

  has_many :user

  validates_presence_of :name

  def to_s
    %Q|#{name}|
  end
end
