class Reservation < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)

  belongs_to :reservable_asset
  belongs_to :user
  has_one :reservable_asset_type, :through => :reservable_asset
  delegate :library, :to => :reservable_asset_type, :allow_nil => true

  validates_presence_of :user, :reservable_asset
  validate :validate_date_span

  after_save :post_save_hooks

  # This scope is meant to allow for easily selecting reservations by
  # status names, via the usual options of keyword, string, and array of same or integers
  scope :status, ->(s) {
    case s
    when Array
      where('status_id IN (?)', s.map {|el| el.is_a?(Integer) ? el : Status[el]})
    else
      where('status_id = ?', Status[s])
    end
  }

  def validate_date_span
    time_in_days = (end_date - start_date).to_i
    min_time = reservable_asset.min_reservation_time.to_i
    max_time = reservable_asset.max_reservation_time.to_i
    errors[:base] << "Start and end date overlap" if time_in_days <= 0
    errors[:base] << "Reservation must be for at least #{min_time} days" if time_in_days < min_time
    errors[:base] << "Reservation cannot be for more than #{max_time} days" if time_in_days > max_time
    errors[:start_date] << "Reservation cannot start in the past" unless start_date >= Date.today or (self.start_date && self.start_date == start_date)
    errors[:end_date] << "End date cannot be before start date" if end_date < start_date
  end

  def post_save_hooks
    notice = ReservationNotice.where(:status_id => self.status_id, :reservable_asset_type_id => self.reservable_asset.reservable_asset_type.id, :library_id => self.reservable_asset.reservable_asset_type.library.id).first
    Email.create(
      :from => self.reservable_asset.reservable_asset_type.library.from,
      :reply_to => self.reservable_asset.reservable_asset_type.library.from,
      :to => self.user.email,
      :bcc => self.reservable_asset.reservable_asset_type.library.bcc,
      :subject => notice.subject,
      :body => notice.message
    )
    Rails.logger.info "Reservation #{self.id} #{self.status.name} notice email created"
  end

  def self.set_expiring_status
    # Find all reservations that are within the expiration extension window,
    #   and set the "expiring" status on it.

    # The trigger for this is located in lib/tasks/bootstrap.rake

    # The select on the end of the query is to prevent an ActiveRecord::ReadOnlyError
    @reservations = ReservableAssetType.all.map do |rat|
      Reservation.joins(:reservable_asset => :reservable_asset_type).
        where('reservable_asset_types.id = ? AND status_id = ? AND end_date - current_date <= ?',
              rat.id,
              Status[:approved],
              rat.expiration_extension_time.to_i).select('reservations.*')
    end.flatten!

    @reservations.each do |reservation|
      rat = reservation.reservable_asset.reservable_asset_type
      reservation.status_id = Status[:expiring]
      reservation.save || Rails.logger.error("ERROR: #{Time.now} Failed to set expiring on reservation #{reservation.id}")
    end
  end

  def self.expire_reservations
    # Find all reservations that should be expired, and expire them
    # The trigger for this is located in lib/tasks/bootstrap.rake

    @reservations = Reservation.where('status_id IN (?) AND end_date <= current_date', Status::ACTIVE_IDS)

    @reservations.each do |reservation|
      reservation.status_id = Status[:expired]
      reservation.save || Rails.logger.error("Could not expire reservation: #{reservation.id}")
    end
  end

  # overloaded - getter without arg, test for equality with arg
  def status(test = nil)
    unless test
      Status.new(self.status_id)
    else
      test_against = Status[test]
      if test_against.is_a? Numeric
        self.status_id == test_against
      else
        test_against.include? self.status_id
      end
    end
  end

  def to_s
    %Q|#{id}|
  end

  def assign_slot
    slots = self.reservable_asset.slots.split(",")
    used_slots = self.reservable_asset.current_reservations.map{|s| s.slot}
    available_slots = slots - used_slots
    unless available_slots.nil?
      available_slots.first
    end
  end

  def allow_edit?(current_user)
    self.user_id == current_user.id && self.pending?
  end

  def pending?
    self.status_id == Status[:pending]
  end

  def declined?
    self.status_id ==  Status[:declined]
  end

  def approved?
    self.status_id ==  Status[:approved]
  end

  def expiring?
    self.status_id == Status[:expiring]
  end
end
