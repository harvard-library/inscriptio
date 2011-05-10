class SubjectAreas < ActiveRecord::Base
  validates_presence_of :name
  
  has_and_belongs_to_many :floors
  has_many :call_numbers
end
