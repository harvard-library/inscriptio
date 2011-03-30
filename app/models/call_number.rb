class CallNumber < ActiveRecord::Base
  has_and_belongs_to_many :floors
  validates_presence_of :call_number
  validates_uniqueness_of :call_number
  has_many :libraries, :through => :floors

  def to_s
    "#{call_number}"
  end

end
