class ReservationNotice < ActiveRecord::Base
  attr_accessible :library, :library_id, :reservable_asset_type, :reservable_asset_type_id, :status,:status_id, :subject, :message, :reply_to

  belongs_to :reservable_asset_type
  belongs_to :status
  belongs_to :library
  belongs_to :reservable_asset_type

  validates_presence_of :subject, :message

  def self.regenerate_notices(rat)
    ReservationNotice.destroy_all(:reservable_asset_type_id => rat.id)

    Status.all.each do |s|
      notice = ReservationNotice.new(:library => rat.library, :reservable_asset_type => rat, :status => s, :subject => s.name, :message => s.name)
      notice.save
      puts "Successfully created #{notice.subject}"
    end
  end

end
