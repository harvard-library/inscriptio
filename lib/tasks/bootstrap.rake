namespace :inscriptio do
  namespace :bootstrap do
    desc "Add the default admin"
    task :default_admin => :environment do
      user = User.new(:email => 'admin@example.com')
      user.first_name = ''
      user.last_name = ''
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
    task :run_all => [:default_admin, :default_message, :default_footer_message, :default_welcome_message, :default_help_message] do
      puts "Created Admin account, Messages, and Notices!"
    end
  end

  namespace :cron_task do
    @per_minutes = [:send_expiration_notices, :send_queued_emails, :delete_posts]
    @per_diems = [:expire_reservations_send_notices]
    desc "Send scheduled emails daily"
    task :send_expiration_notices => :environment do
      @reservations = Array.new
      ReservableAssetType.all.each do |at|
        @reservations << Reservation.find(:all, :conditions => ['status_id = ? AND end_date - current_date = ?', Status[:approved], at.expiration_extension_time.to_i])
      end
      @reservations.flatten!

      notices = ReservationNotice.where(:status_id => Status[:approved]).reduce({}) do |notices, rn|
        notices[rn.reservable_asset_type_id] = rn
        notices
      end

      @reservations.each do |reservation|
        rat = reservation.reservable_asset.reservable_asset_type
        Email.create(
          :from => rat.library.from,
          :reply_to => rat.library.from,
          :to => reservation.user.email,
          :bcc => rat.library.bcc,
          :subject => notices[rat.id].subject,
          :body => notices[rat.id].message
        )
      end
      puts "Successfully delivered expiration notices!"
    end

    desc "Sets expired status on reservations and generates an email."
    task :expire_reservations_send_notices => :environment do
      @reservations = Reservation.find(:all, :conditions => ['status_id = ? AND end_date <= current_date', Status[:approved]])
      notices = ReservationNotice.where(:status_id => Status[:expired]).reduce({}) do |notices, rn|
        notices[rn.reservable_asset_type_id] = rn
        notices
      end

      @reservations.each do |reservation|
        reservation.status_id = Status[:expired]
        if reservation.save
          rat = reservation.reservable_asset.reservable_asset_type
          Email.create(
            :from => rat.library.from,
            :reply_to => rat.library.from,
            :to => reservation.user.email,
            :bcc => rat.library.bcc,
            :subject => notices[rat.id].subject,
            :body => notices[rat.id].message
          )
        else
          logger.error "Could not expire reservation: #{reservation.id}"
        end
        puts "Successfully delivered expired notices!"
      end
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
    task :run_all => @per_minutes do
      puts "Sent all notices and deleted old bulletin board posts!"
    end

    desc "Set up crontab"
    task :setup_crontab do
      tmp = Tempfile.new('crontab')
      tmp.write `crontab -l`.sub(/^[^\n#]*#INSCRIPTIO_AUTO_CRON_BEGIN.*#INSCRIPTIO_AUTO_CRON_END\n?/m, '')
      tmp.write "#INSCRIPTIO_AUTO_CRON_BEGIN\n"

      per_min_time = "*/5 * * * *"
      per_diem_time = "0 12 * * *"
      preamble = "cd #{ENV['RAKE_ROOT'] || Rails.root} && #{`which rvm`.chomp} default do bundle exec #{`which rake`.chomp} inscriptio:cron_task:"
      env = "RAILS_ENV=#{ENV['RAILS_ENV']}"

      @per_minutes.each do |pm|
        tmp.write "#{per_min_time} #{preamble}#{pm.to_s} #{env}\n"
      end
      @per_diems.each do |pm|
        tmp.write "#{per_diem_time} #{preamble}#{pm.to_s} #{env}\n"
      end
      tmp.write "#INSCRIPTIO_AUTO_CRON_END\n"
      tmp.close
      success = system 'crontab', tmp.path
      puts 'Crontab added' if success
    end
  end
end
