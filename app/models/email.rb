class Email < ActiveRecord::Base
  belongs_to :user, :primary_key => :email, :foreign_key => :to
  validates_presence_of :to, :from, :reply_to, :subject, :body

  def self.to_send
    self.where(:message_sent => false).limit(EMAIL_BATCH_LIMIT)
  end

  def self.send_queued_emails
    Email.to_send.each do |email|
      begin
        Notification.send_queued(email).deliver
        email.message_sent = true
        email.date_sent = Time.now
        email.save
      rescue Exception => e
        #FAIL!
        email.error_message = e.inspect[0..4999]
        email.message_sent = false
        email.save
        Rails.logger
      end
    end
  end

end
