class Email < ActiveRecord::Base
  
  validates_presence_of :to
  validates_presence_of :subject
  validates_presence_of :body
end
