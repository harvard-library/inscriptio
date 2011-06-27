class SubjectArea < ActiveRecord::Base
  has_and_belongs_to_many :floors, :order => :name
  has_many :call_numbers
  has_many :libraries, :through => :floors
  
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
