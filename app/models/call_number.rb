class CallNumber < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  has_and_belongs_to_many :floors, ->{ order "name"}
  belongs_to :subject_area
  has_one :library, :through => :subject_area

  validates_presence_of :subject_area
  validates_presence_of :call_number
  validates_uniqueness_of :call_number
  validates_length_of :call_number, :minimum => 1, :maximum => 50

  validates_length_of :description, :maximum => 16.kilobytes, :allow_blank => true

  def to_s
    "#{call_number}"
  end

  def self.search(search)
    if search
      where("lower(call_number) LIKE ? or lower(long_name) LIKE ?", "%#{search}%", "%#{search}%")
    end
  end

end
