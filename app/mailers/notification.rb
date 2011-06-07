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
end
