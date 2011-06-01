class Notification < ActionMailer::Base
  default :from => "apatel@cyber.law.harvard.edu"
  
  def reservation_requested(reservation)
      @reservation = reservation
      mail(:to => @reservation.user.email,
           :subject => "Your reservation has been submitted.")
  end
  
  def reservation_approved(reservation)
      @reservation = reservation
      mail(:to => @reservation.user.email,
           :subject => "Your reservation has been approved.")
  end
end
