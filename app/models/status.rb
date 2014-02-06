# Reservation statuses: These are the source of status_id values
#  in the reservations table. New values can be added, but
#  existing numbers should not be changed or removed without
#  great care
class Status
  attr_reader :name, :id
  STATUSES = {
    "Approved" => 1,
    "Pending" =>  2,
    "Declined" => 3,
    "Waitlist" => 4,
    "Expired" =>  5,
    "Expiring" => 6,
    "Cancelled" => 7,
    "Renewal Confirmation" => 8
  }
  ACTIVE_IDS = STATUSES.reduce([]) do |acc, (k,v)|
    acc.push v if ['Approved', 'Pending', 'Expiring'].include?(k)
    acc
  end

  # Only ever create one object per status
  @@status_obj_cache = {}

  def self.new(id)
    if @@status_obj_cache[id]
      @@status_obj_cache[id]
    else
      super(id)
    end
  end

  def initialize(id)
    @name = STATUSES.invert[id]
    @id = id
    self.freeze
    @@status_obj_cache[id] = self
  end

  # Status names must be of the format /\p{upper}\p{lower}+(\s\p{upper}\p{lower}+)*/
  #  This will convert symbols of the form /:\p{lower}+(_\p{lower}+)*/ into said form
  def self.canonicalize s_token
    s_token.to_s.split('_').map(&:capitalize).join(' ')
  end

  # A class subscript method to shortcut getting IDs for DB use
  def self.[](*args)
    if args.length == 1
      args = args.pop
    end
    case args
    when String
      STATUSES[args]
    when Symbol
      STATUSES[canonicalize(args)]
    when Array
      args = args.map {|s| canonicalize s}
      STATUSES.select { |el| args.include? el}.values
    else
      raise "I don't understand that as a status or list of statuses"
    end
  end

  def self.to_hash
    STATUSES
  end

  def to_s
    @name
  end

end
