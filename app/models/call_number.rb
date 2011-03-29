class CallNumber < ActiveRecord::Base
  has_and_belongs_to_many :floors
  validates_presence_of :call_number

  def to_s
    "#{call_number}"
  end

end
