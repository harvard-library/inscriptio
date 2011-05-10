class CallNumber < ActiveRecord::Base
  has_and_belongs_to_many :floors, :order => :name
  belongs_to :subject_area

  validates_presence_of :call_number
  validates_uniqueness_of :call_number
  validates_length_of :call_number, :minimum => 1, :maximum => 50

  validates_length_of :description, :maximum => 16.kilobytes, :allow_blank => true
  has_many :libraries, :through => :floors

  def to_s
    "#{call_number}"
  end

end
