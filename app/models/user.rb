class User < ActiveRecord::Base
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_type_id, :school_affiliation_id, :first_name, :last_name
  
  belongs_to :user_type
  belongs_to :school_affiliation
  has_many :reservations
  has_many :reservable_assets, :through => :reservations
  has_many :posts
  has_many :moderator_flags
  has_many :emails
#  has_one :authentication_source, :through => :user_type

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  after_create :post_save_hooks
  
  def to_s
    %Q|#{email}|
  end 
  
  def self.search(search)
    if search
      find(:all, :conditions => ['lower(email) LIKE ?', "%#{search}%"])
    end
  end
  
  def self.random_password(size = 11)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end  
  
  def post_save_hooks
    Email.create(
      :from => Library.find(:first).from,
      :reply_to => Library.find(:first).from,
      :to => self.email,
      :subject => "Your Inscriptio Account Has Been Created",
      :body => %Q|<p>Welcome to Inscriptio, the online library carrel and hold shelf reservation system.</p><p>Your login is: #{self.email}. Please visit <a href="#{ROOT_URL}/users/password/new">Inscriptio</a> to create a new password and log into your account.</p>|
    )
  end    
  
end
