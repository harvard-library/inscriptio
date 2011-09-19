namespace :inscriptio do
  namespace :utils do
    desc "Reset all post lifetimes to 30 days"
    task :reset_lifetime => :environment do
      bbs = BulletinBoard.find(:all, :conditions => {:post_lifetime => 1})
      bbs.each do |bb|
        bb.post_lifetime = 30
        bb.save
      end 
    end
  end
end
