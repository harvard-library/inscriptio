namespace :inscriptio do
  namespace :bootstrap do
    desc "Add the default admin"
    task :default_admin => :environment do
      user = User.new(:email => 'admin@email.com')
      user.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{rand(1<<64)}--")[0,6]
      user.admin = true
      user.save
      puts "Admin email is: #{user.email}"
      puts "Admin password is: #{user.password}"
    end
    
    desc "Add the default statuses"
    task :default_statuses => :environment do
      statuses = ["Approved", "Pending", "Declined", "Waitlist", "Expired", "Expiring", "Renewal Confirmation"]
      statuses.each do |s|
        status = Status.new(:name => s)
        status.save
        puts "Successfully created #{status.name}"
      end  
    end
    
    desc "Add the default notices"
    task :default_notices => :environment do
      statuses = Status.all
      statuses.each do |s|
        notice = ReservationNotice.new(:status => s, :subject => s.name, :message => s.name)
        notice.save
        puts "Successfully created #{notice.subject}"
      end  
    end
    
    desc "run all tasks in bootstrap"
    task :run_all => [:default_admin, :default_statuses, :default_notices] do
      puts "Created Admin account, Statuses and Notices!"
    end
      
  end
end