namespace :inscriptio do
  namespace :bootstrap do
    desc "Add the default admin"
    task :default_admin => :environment do
      user = User.new(:email => 'admin@example.com')
      if %w[development test dev local].include?(Rails.env)
        user.password = User.random_password(size = 6)
      else
        user.password = User.random_password
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
    
    task :default_welcome_message => :environment do
      message = Message.new(:title => "Default Welcome Message", :content => "Please create this message.", :description => "welcome")
      message.save
      puts "Successfully created default welcome message!"
    end
    
    task :default_footer_message => :environment do
      message = Message.new(:title => "Default Footer Message", :content => "Please create this message.", :description => "footer")
      message.save
      puts "Successfully created default footer message!"
    end
    
    task :default_help_message => :environment do
      message = Message.new(:title => "Default Help Message", :content => "Please create this message.", :description => "help")
      message.save
      puts "Successfully created default help message!"
    end
    
    desc "run all tasks in bootstrap"
    task :run_all => [:default_admin, :default_statuses, :default_message, :default_footer_message, :default_welcome_message, :default_help_message] do
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
      notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expiring'"])})
      @reservations.each do |reservation|
        Email.create(
          :from => reservation.reservable_asset.reservable_asset_type.library.from,
          :reply_to => reservation.reservable_asset.reservable_asset_type.library.from,
          :to => reservation.user.email,
          :bcc => reservation.reservable_asset.reservable_asset_type.library.bcc,
          :subject => notice.subject,
          :body => notice.message
        )
      end  
      puts "Successfully delivered expiration notices!"
    end
    
    task :send_expired_notices => :environment do
      @reservations = Reservation.find(:all, :conditions => ['approved = true AND end_date <= current_date'])
      @reservations.each do |reservation|
        reservation.status = Status.find(:first, :conditions => ["lower(name) = 'expired'"])
        reservation.save  
        Email.create(
          :from => reservation.reservable_asset.reservable_asset_type.library.from,
          :reply_to => reservation.reservable_asset.reservable_asset_type.library.from,
          :to => reservation.user.email,
          :bcc => reservation.reservable_asset.reservable_asset_type.library.bcc,
          :subject => notice.subject,
          :body => notice.message
        )
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
    
    desc "Send emails that are queued up"
    task :send_queued_emails => :environment do
      emails = Email.to_send
      emails.each do |email|
        begin
          Notification.send_queued(email).deliver
          email.message_sent = true
          email.date_sent = Time.now
          email.save
          end
        rescue Exception => e
          #FAIL!
          email.error_message = e.inspect[0..4999]
          email.to_send = false
          email.save
        end
      end  
      puts "Successfully sent queued emails!" 
    end
    
    desc "run all tasks in cron_task"
    task :run_all => [:send_expiration_notices, :send_expired_notices, :send_queued_emails, :delete_posts] do
      puts "Sent all notices and deleted old bulletin board posts!"
    end
    
  end  
end