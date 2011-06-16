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
  end
end