namespace :inscriptio do
  desc "Send scheduled emails daily"
  task :send_mail => :environment do
    Notification.reservation_expiration.deliver
  end
end
