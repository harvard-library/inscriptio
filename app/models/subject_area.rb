class SubjectArea < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)

  has_many :floors,  -> { order "name" }, :through => :call_numbers
  has_many :call_numbers, :dependent => :destroy
  belongs_to :library

  validates_presence_of :name
  validates_length_of :description, :maximum => 16.kilobytes, :allow_blank => true

  def to_s
    %Q|#{name}|
  end

  def self.search(search)
    if search
      where("lower(name) LIKE ? or lower(long_name) LIKE ?", "%#{search}%", "%#{search}%")
    end
  end
end
