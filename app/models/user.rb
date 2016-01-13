require 'mail'

# Originally Taken from https://github.com/hallelujah/valid_email, which relied on treetop in Mail
# modified to just regex-test the domain, to ensure it's alpha, between 2-4 chars, etc.
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record,attribute,value)
    begin
      m = Mail::Address.new(value)
      # We must check that value contains a domain and that value is an email address
      r = m.domain && m.address == value
      # user@localhost is excluded
      # DEPRECATED (and not clear it ever worked!): We exclude valid email values like <user@localhost.com>
      r &&= (m.domain.match /^(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}$/ )
    rescue Exception => e
      r = false
    end
    record.errors[attribute] << (options[:message] || "is an invalid email address") unless r
  end
end

class User < ActiveRecord::Base
  acts_as_paranoid # provided by Paranoia (https://github.com/radar/paranoia)
  include ActionView::Helpers::UrlHelper
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,# :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :remember_me, :school_affiliation_id, :first_name, :last_name, :password

  has_and_belongs_to_many :user_types
  belongs_to :school_affiliation
  has_many :reservations, :dependent => :destroy
  has_many :reservable_assets, :through => :reservations
  has_many :posts, :dependent => :destroy
  has_many :moderator_flags, :dependent => :destroy
  has_many :emails, :primary_key => :email, :foreign_key => :to, :dependent => :destroy
  has_and_belongs_to_many(:local_admin_permissions,
                          :class_name => 'Library',
                          :join_table => :libraries_users_admin_permissions)
  has_many :libraries, :through => :user_types

  validates :email, :presence => true, :email => true, :uniqueness => true

  after_create :post_save_hooks

  def to_s
    %Q|#{email}|
  end

  def self.search(search)
    if search
      where("lower(email) LIKE ?", "%#{search}%")
    end
  end

  def self.can_reserve(rat_id)
    allowed_types = ReservableAssetType.find(rat_id).user_type_ids
    User.joins(:user_types).where('user_types.id IN (?)', allowed_types)
  end


  def self.random_password(size = 11)
    chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
    (1..size).collect{|a| chars[rand(chars.size)] }.join
  end

  def post_save_hooks
    Email.create(
      :from => DEFAULT_MAILER_SENDER,
      :reply_to => DEFAULT_MAILER_SENDER,
      :to => self.email,
      :subject => "Your Inscriptio Account Has Been Created",
      :body => %Q|<p>Welcome to Inscriptio, the online library carrel and hold shelf reservation system.</p><p>Your login is: #{self.email}. Please visit <a href="#{ROOT_URL}/users/password/new">Inscriptio</a> to create a new password and log into your account.</p>|
    )
  end

end
