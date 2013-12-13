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
      adapter_type = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
      case adapter_type
      when :mysql, :mysql2
        ActiveRecord::Base.connection.execute('TRUNCATE TABLE statuses')
      when :sqlite
        Status.destroy_all
        ActiveRecord::Base.connection.execute("DELETE FROM statuses;DELETE FROM sqlite_sequence WHERE name = 'statuses';")
      when :postgresql
        Status.destroy_all
        ActiveRecord::Base.connection.reset_pk_sequence!('statuses')
      else
        raise NotImplementedError, "Unknown adapter type '#{adapter_type}'"
      end

      STATUSES.each do |s|
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
    @cron_tasks = [:send_expiration_notices, :send_expired_notices, :send_queued_emails, :delete_posts]
    desc "Send scheduled emails daily"
    task :send_expiration_notices => :environment do
      @reservations = Array.new
      ReservableAssetType.all.each do |at|
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

    desc "Sets expired status on reservations and generates an email."
    task :send_expired_notices => :environment do
      @reservations = Reservation.find(:all, :conditions => ['status_id = ? AND end_date <= current_date', Status.find(:first, :conditions => ["lower(name) = 'approved'"])])
      notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'expired'"])})
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
              if Date.today - post.created_at.to_date >= bb.post_lifetime
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
    task :run_all => @cron_tasks do
      puts "Sent all notices and deleted old bulletin board posts!"
    end

    desc "Set up crontab"
    task :setup_crontab do
      tmp = Tempfile.new('crontab')
      tmp.write `crontab -l`.sub(/^[^\n#]*#INSCRIPTIO_AUTO_CRON_BEGIN.*#INSCRIPTIO_AUTO_CRON_END\n?/m, '')
      tmp.write "#INSCRIPTIO_AUTO_CRON_BEGIN
*/5 * * * * cd #{ENV['RAKE_ROOT'] || Rails.root} && #{`which rvm`.chomp} 1.9 do bundle exec #{`which rake`.chomp} inscriptio:cron_task:run_all
#INSCRIPTIO_AUTO_CRON_END\n"
      tmp.close
      success = system 'crontab', tmp.path
      puts 'Crontab added' if success
    end
  end
end
