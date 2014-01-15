class Reservation < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  attr_accessible :reservable_asset_id, :reservable_asset, :user_id, :user, :status_id, :status, :start_date, :end_date, :tos, :slot

  belongs_to :reservable_asset
  belongs_to :user
  belongs_to :status

  validates_presence_of :user, :reservable_asset
  validate :validate_date_span => {:except => [:archive]}

  after_save :post_save_hooks, :except => [:archive]
  after_destroy :post_destroy_hooks

  scope :status, ->(s) {
    rel = joins(:status)

    case s
    when String
      rel.where('statuses.name = ?', s)
    when Symbol
      rel.where('statuses.name = ?', s.to_s.split('_').map(&:capitalize).join(' '))
    when Array
      rel.where('statuses.name IN (?)', s.map {|s| s.to_s.split('_').map(&:capitalize).join(' ')})
    else
      raise "I don't understand that as a status or list of statuses"
    end
  }

  def post_save_hooks
    notice = ReservationNotice.find(:first, :conditions => {:status_id => self.status_id, :reservable_asset_type_id => self.reservable_asset.reservable_asset_type.id, :library_id => self.reservable_asset.reservable_asset_type.library.id})
    Email.create(
      :from => self.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.reservable_asset.reservable_asset_type.library.from,
      :to => self.user.email,
      :bcc => self.reservable_asset.reservable_asset_type.library.bcc,
      :subject => notice.subject,
      :body => notice.message
    )
  end

  def post_destroy_hooks
    notice = ReservationNotice.find(:first, :conditions => {:status_id => Status.find(:first, :conditions => ["lower(name) = 'cancelled'"]), :reservable_asset_type_id => self.reservable_asset.reservable_asset_type.id, :library_id => self.reservable_asset.reservable_asset_type.library.id})
    Email.create(
      :from => self.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.reservable_asset.reservable_asset_type.library.from,
      :to => self.user.email,
      :bcc => self.reservable_asset.reservable_asset_type.library.bcc,
      :subject => notice.subject + " " + self.reservable_asset.name,
      :body => notice.message
    )

  end

  def archive
    self.status_id = Status.find_by_name('Archived').id
    self.save!
  end

  def to_s
    %Q|#{id}|
  end

  def allow_edit?(current_user)
    self.user_id == current_user.id && self.pending?
  end

  def validate_date_span
    time_in_days = (end_date - start_date).to_i
    min_time = reservable_asset.min_reservation_time.to_i
    max_time = reservable_asset.max_reservation_time.to_i
    errors[:base] << "Start and end date overlap" if time_in_days <= 0
    errors[:base] << "Reservation must be for at least #{min_time} days" if time_in_days < min_time
    errors[:base] << "Reservation cannot be for more than #{max_time} days" if time_in_days > max_time
    errors[:start_date] << "Reservation cannot start in the past" unless start_date >= Date.today
    errors[:end_date] << "End date cannot be before start date" if end_date < start_date
  end

  def assign_slot
    slots = self.reservable_asset.slots.split(",")
    used_slots = self.reservable_asset.current_reservations.map{|s| s.slot}
    available_slots = slots - used_slots
    unless available_slots.nil?
      available_slots.first
    end
  end

  def pending?
    pending = Status.find(:first, :conditions => ["lower(name) = 'pending'"])
    self.status == pending
  end

  def declined?
    declined = Status.find(:first, :conditions => ["lower(name) = 'declined'"])
    self.status == declined
  end

  def approved?
    approved = Status.find(:first, :conditions => ["lower(name) = 'approved'"])
    self.status == approved
  end

  def expiring?
    self.status == Status.find(:first, :conditions => ["lower(name) = 'approved'"]) && self.end_date - Date.today <= self.reservable_asset.reservable_asset_type.expiration_extension_time.to_i
  end
end
