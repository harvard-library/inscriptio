namespace :inscriptio do
  namespace :bootstrap do
    desc "Add the default admin"
    task :default_admin => :environment do
      user = User.new(:email => 'admin@example.com')
      user.first_name = 'Admin'
      user.last_name = 'McAdmin'
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
    @per_minutes = [:set_expiring_status, :send_queued_emails, :delete_posts]
    @per_diems = [:expire_reservations]

    desc "Sets expiring status on reservations that are about to expire"
    task :set_expiring_status => :environment do
      Reservation.set_expiring_status
      puts "Marked \"soon to expire\" reservations."
    end

    desc "Sets expired status on reservations that have expired."
    task :expire_reservations => :environment do
      Reservation.expire_reservations
      puts "Expired reservations."
    end

    desc "Delete bulletin board posts after lifetime"
    task :delete_posts => :environment do
      BulletinBoard.prune_posts
      puts "Deleted expired posts."
    end

    desc "Send emails that are queued up"
    task :send_queued_emails => :environment do
      Email.send_queued_emails
      puts "Sent queued emails."
    end

    desc "Set up crontab"
    task :setup_crontab do
      tmp = Tempfile.new('crontab')
      tmp.write `crontab -l`.sub(/^[^\n#]*#INSCRIPTIO_AUTO_CRON_BEGIN.*#INSCRIPTIO_AUTO_CRON_END\n?/m, '')
      tmp.write "#INSCRIPTIO_AUTO_CRON_BEGIN\n"
      tmp.write "# Modified as of #{Time.now}\n"
      tmp.write "# This block is generated by Inscriptio as part of deploy.\n"
      tmp.write "# Please update timestamp if you make manual alterations.\n"

      per_min_time = "*/5 * * * *"
      per_diem_time = "1 12 * * *"
      preamble = "cd #{ENV['RAKE_ROOT'] || Rails.root} && #{`which rvm`.chomp} default do bundle exec #{`which rake`.chomp} inscriptio:cron_task:"
      env = "RAILS_ENV=#{ENV['RAILS_ENV']}"
      redirect = '> /dev/null 2>&1'

      @per_minutes.each do |pm|
        tmp.write "#{per_min_time} #{env} #{preamble}#{pm.to_s} #{redirect}\n"
      end
      @per_diems.each do |pm|
        tmp.write "#{per_diem_time} #{env} #{preamble}#{pm.to_s} #{redirect}\n"
      end
      tmp.write "#INSCRIPTIO_AUTO_CRON_END\n"
      tmp.close
      success = system 'crontab', tmp.path
      puts 'Crontab added' if success
    end
  end
end
