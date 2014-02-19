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
    @per_minutes = [:set_expiring_status, :send_queued_emails, :delete_posts]
    @per_diems = [:expire_reservations]
    desc "Send scheduled emails daily"
    task :set_expiring_status => :environment do
      Reservation.set_expiring_status
    end

    desc "Sets expired status on reservations and generates an email."
    task :expire_reservations => :environment do
      Reservation.expire_reservations
    end

    desc "Delete bulletin board posts after lifetime"
    task :delete_posts => :environment do
      BulletinBoard.prune_posts
      puts "Successfully deleted expired posts!"
    end

    desc "Send emails that are queued up"
    task :send_queued_emails => :environment do
      Email.send_queued_emails
      puts "Successfully sent queued emails!"
    end

    desc "Set up crontab"
    task :setup_crontab do
      tmp = Tempfile.new('crontab')
      tmp.write `crontab -l`.sub(/^[^\n#]*#INSCRIPTIO_AUTO_CRON_BEGIN.*#INSCRIPTIO_AUTO_CRON_END\n?/m, '')
      tmp.write "#INSCRIPTIO_AUTO_CRON_BEGIN\n"

      per_min_time = "*/5 * * * *"
      per_diem_time = "1 12 * * *"
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
