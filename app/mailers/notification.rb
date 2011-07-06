class Notification < ActionMailer::Base
  default :from => "apatel@cyber.law.harvard.edu"
  
  def reservation_notice(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status => @reservation.status})
      mail(:to => @reservation.user.email,
           :subject => @notice.subject)
  end
  
  def reservation_canceled(reservation)
      @reservation = reservation
      mail(:to => @reservation.user.email,
           :subject => "Your reservation has been canceled.")
  end
  
  def bulletin_board_posted(post)
      @post = post
      @bulletin_board = @post.bulletin_board
      mail(:to => @post.bulletin_board.users.email,
           :subject => "A New Post to Bulletin Board")
  end
  
  def reservation_expiration
      @expiration_notice = ReservationExpirationNotice.find(:first, :conditions => {:notice_type => "actual"})
      @reservations = Reservation.find(:all, :conditions => ['approved = true AND end_date - current_date = ?', @expiration_notice.days_before_expiration.to_i])
      @reservations.each do |reservation|
        mail(:to => reservation.user.email,
             :subject => @expiration_notice.subject)
      end  
  end  
end
