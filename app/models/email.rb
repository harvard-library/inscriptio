class Email < ActiveRecord::Base
  attr_accessible :to, :from, :reply_to, :subject, :bcc, :body

  validates_presence_of :to, :from, :reply_to, :subject, :body

  def self.to_send
    self.find(:all, :conditions => {:message_sent => false}, :limit => EMAIL_BATCH_LIMIT)
  end
end
