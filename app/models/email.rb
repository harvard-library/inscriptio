class Email < ActiveRecord::Base
  
  validates_presence_of :to, :from, :reply_to, :subject, :body
  
  def self.to_send
    self.find(:all, :conditions => {:message_sent => false})
  end
end
