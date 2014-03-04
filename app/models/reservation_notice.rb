class ReservationNotice < ActiveRecord::Base
  attr_accessible :library, :library_id, :reservable_asset_type, :reservable_asset_type_id, :status_id, :subject, :message, :reply_to

  belongs_to :reservable_asset_type
  belongs_to :library
  belongs_to :reservable_asset_type

  validates_presence_of :subject, :message

  DEFAULT_MESSAGES = {
    "Approved" => "Your reservation has been approved. If you have any questions please reply to this email.",
    "Pending" => "Thank you for your application. It is currently pending and you will be notified when it has been approved. If you have any questions please reply to this email.",
    "Declined" => "Your application has been declined. Please contact the office to which you submitted this application for further information or reply to this email.",
    "Waitlist" => "Your application has been wait-listed. Please contact the office to which you submitted this application with any questions or reply to this email.",
    "Expired" => "Your reservation has expired. If you have any questions please reply to this email.",
    "Expiring" => "Your reservation is expiring soon. Please log in to your account if you would like to renew. If you have any questions please reply to this email.",
    "Cancelled" => "Your reservation has been cancelled. If you have any questions please reply to this email.",
    "Renewal confirmation" => "Your reservation has been renewed. If you have any questions please reply to this email."

  }

  def status
    Status.new(self.status_id)
  end

  def self.regenerate_notices(rat)
    ReservationNotice.destroy_all(:reservable_asset_type_id => rat.id)

    Status.to_hash.each do |s_name, s_id|
      message = DEFAULT_MESSAGES[s_name] ? DEFAULT_MESSAGES[s_name] : s_name
      reply_to = rat.library.from ? rat.library.from : nil
      notice = ReservationNotice.new(:library => rat.library,
                                     :reservable_asset_type => rat,
                                     :status_id => s_id,
                                     :subject => s_name,
                                     :message => message,
                                     :reply_to => reply_to)
      notice.save
    end
  end

end
