class Notification < ActionMailer::Base
  default :from => User.find(:first, :conditions => {:admin => true})
  
  def reservation_notice(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => @reservation.status_id})
      mail(:to => @reservation.user.email,
           :subject => @notice.subject)
  end
  
  def reservation_canceled(reservation, email)
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'cancelled'"])})
      @reservation = reservation
      mail(:to => email,
           :subject => @notice.subject)
  end
  
  def reservation_expiration(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expiring'"])})
      @reservations = Array.new
      mail(:to => @reservation.user.email,
             :subject => @notice.subject)  
  end
  
  def reservation_expired(reservation)
      @reservation = reservation
      @notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expired'"])})
      mail(:to => @reservation.user.email,
             :subject => @notice.subject)  
  end
  
  def bulletin_board_posted(post)
      @post = post
      @bulletin_board = @post.bulletin_board
      mail(:to => user.email,
           :subject => "A New Post to Bulletin Board")
  end
  
  def moderator_flag_set(post, email)
      @post = post
      @bulletin_board = @post.bulletin_board
      mail(:to => email,
           :subject => "A Moderator Flag has been set.")       
  end
  
  def account_created(user, password)
      @user = user
      @password = password
      mail(:to => user.email,
           :subject => "Your Account Has Been Created")       
  end
    
end
