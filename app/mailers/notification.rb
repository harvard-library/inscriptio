class Notification < ActionMailer::Base
  default :from => User.find(:first, :conditions => {:admin => true})
  
  def reservation_notice(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => @reservation.status_id})
      mail(:to => @reservation.user.email,
           :subject => @notice.subject)
  end
  
  def reservation_canceled(reservation)
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'cancelled'"])})
      @reservation = reservation
      mail(:to => @reservation.user.email,
           :subject => @notice.subject)
  end
  
  def reservation_expiration
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expiring'"])})
      @reservations = Array.new
      @asset_types.all.each do |at|
        @reservations << Reservation.find(:all, :conditions => ['status_id = ? AND end_date - current_date = ?', Status.find(:first, :conditions => ["lower(name) = 'approved'"]), at.expiration_extension_time.to_i])  
      end  
      @reservations.flatten!
      @reservations.each do |reservation|
        mail(:to => reservation.user.email,
             :subject => @notice.subject)
      end  
  end
  
  def reservation_expired
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expired'"])})
      @reservations = Reservation.find(:all, :conditions => ['approved = true AND end_date = current_date'])
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
      @post.bulletin_board.users.each do |user|
        mail(:to => user.email,
             :subject => "A New Post to Bulletin Board")
      end       
  end
  
  def moderator_flag_set(post)
      @admins = User.find(:all, :conditions => {:admin => true})
      @post = post
      @bulletin_board = @post.bulletin_board
      @admins.each do |admin|
        mail(:to => admin.email,
             :subject => "A Moderator Flag has been set.")
      end       
  end
    
end
