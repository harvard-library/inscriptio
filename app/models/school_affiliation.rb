class SchoolAffiliation < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates_presence_of :name

  def to_s
    %Q|#{name}|
  end
end
