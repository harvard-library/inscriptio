class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_type_id
  
  belongs_to :user_type
  has_many :reservations
  has_many :reservable_assets, :through => :reservations
  has_many :posts
  has_many :moderator_flags
#  has_one :authentication_source, :through => :user_type

  validates_presence_of :email
  
  def to_s
    %Q|#{email}|
  end 
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(email) LIKE ?', "%#{search}%"])
    end
  end
end
