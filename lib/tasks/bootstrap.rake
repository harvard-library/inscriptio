namespace :inscriptio do
  namespace :bootstrap do
    desc "Add the default admin"
    task :default_admin => :environment do
      user = User.new(:email => 'admin@example.com')
      if %w[development test dev local].include?(Rails.env)
        user.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand(1<<64)}--")[0,6]
      else
        user.password = (0..11).inject(""){|s,i| s << (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).rand}
      end
      user.admin = true
      user.save
      puts "Admin email is: #{user.email}"
      puts "Admin password is: #{user.password}"
    end
    
    desc "Add the default statuses"
    task :default_statuses => :environment do
      statuses = ["Approved", "Pending", "Declined", "Waitlist", "Expired", "Expiring", "Cancelled", "Renewal Confirmation"]
      statuses.each do |s|
        status = Status.new(:name => s)
        status.save
        puts "Successfully created #{status.name}!"
      end  
    end
    
    desc "Add the default message"
    task :default_message => :environment do
      message = Message.new(:title => "Default Message", :content => "Please create this message.", :description => "default")
      message.save
      puts "Successfully created default message!"
    end
    
    desc "run all tasks in bootstrap"
    task :run_all => [:default_admin, :default_statuses, :default_message] do
      puts "Created Admin account, Statuses and Notices!"
    end 
  end
  
  namespace :cron_task do
    desc "Send scheduled emails daily"
    task :send_expiration_notices => :environment do
      @asset_types.all.each do |at|
        @reservations << Reservation.find(:all, :conditions => ['status_id = ? AND end_date - current_date = ?', Status.find(:first, :conditions => ["lower(name) = 'approved'"]), at.expiration_extension_time.to_i])  
      end  
      @reservations.flatten!
      @reservations.each do |reservation|
        Notification.reservation_expiration(reservation).deliver
      end  
      puts "Successfully delivered expiration notices!"
    end
    
    task :send_expired_notices => :environment do
      @reservations = Reservation.find(:all, :conditions => ['approved = true AND end_date = current_date'])
      @reservations.each do |reservation|
        reservation.status = Status.find(:first, :conditions => ["lower(name) = 'expired'"])
        reservation.save  
        Notification.reservation_expired(reservation).deliver
      end
      puts "Successfully delivered expired notices!"
    end
    
    desc "Delete bulletin board posts after lifetime"
    task :delete_posts => :environment do
      @bulletin_boards = BulletinBoard.all
      unless @bulletin_boards.nil?
        @bulletin_boards.each do |bb|
          unless bb.posts.nil?
            bb.posts.each do |post|
              if Date.today - post.created_at.to_datetime >= bb.post_lifetime
                Post.destroy(post)
              end  
            end  
          end
        end
      end
      puts "Successfully deleted expired posts!" 
    end
    
    desc "run all tasks in cron_task"
    task :run_all => [:send_expiration_notices, :send_expired_notices, :delete_posts] do
      puts "Sent all notices and deleted old bulletin board posts!"
    end
    
  end  
end