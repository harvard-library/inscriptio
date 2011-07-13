class Notification < ActionMailer::Base
  default :from => "apatel@cyber.law.harvard.edu"
  
  def reservation_notice(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => @reservation.status_id})
      mail(:to => @reservation.user.email,
           :subject => @notice.subject)
  end
  
  def reservation_canceled(reservation)
      @reservation = reservation
      mail(:to => @reservation.user.email,
           :subject => "Your reservation has been canceled.")
  end
  
  def reservation_expiration
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expiring'"])})
      @reservations = Reservation.find(:all, :conditions => ['status_id = ? AND end_date - current_date = 14', Status.find(:first, :conditions => ["lower(name) = 'approved'"])])
      @reservations.each do |reservation|
        mail(:to => reservation.user.email,
             :subject => @notice.subject)
      end  
  end
  
  def reservation_expired
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expired'"])})
      @reservations = Reservation.find(:all, :conditions => ['approved = true AND end_date = current_date='])
      @reservations.each do |reservation|
        reservation.status = Status.find(:first, :conditions => ["lower(name) = 'expired'"])
        reservation.save
        mail(:to => reservation.user.email,
             :subject => @notice.subject)
      end  
  end
  
  def bulletin_board_posted(post)
      @post = post
      @bulletin_board = @post.bulletin_board
      mail(:to => @post.bulletin_board.users.email,
           :subject => "A New Post to Bulletin Board")
  end
    
end
