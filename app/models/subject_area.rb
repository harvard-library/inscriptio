class SubjectArea < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  attr_accessible :name, :long_name, :description, :call_number_ids, :library_id

  has_many :floors, :through => :call_numbers, :order => :name
  has_many :call_numbers, :dependent => :destroy
  belongs_to :library

  validates_presence_of :name
  validates_length_of :description, :maximum => 16.kilobytes, :allow_blank => true

  def to_s
    %Q|#{name}|
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['lower(name) LIKE ? or lower(long_name) LIKE ?', "%#{search}%", "%#{search}%"])
    end
  end
end
