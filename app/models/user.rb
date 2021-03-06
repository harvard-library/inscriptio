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
      :body => construct_body
    )
  end

  def construct_body
    body = <<BODY
<p>Welcome to Inscriptio, the online library carrel and hold shelf reservation system!</p>
 <p>In order to complete the registration process, you must perform the following steps:</p>
 <ol><li> #{%Q(Visit Inscriptio's "New user" page at   <a href="http://#{ROOT_URL}/users/password/new">http://#{ROOT_URL}/users/password/new</a>)} . 
<ul><li>You will be prompted to enter your email address, #{self.email} , which is your login</li>
<li>Then click on #{%Q("Send me set/reset password instructions")}</li></ul>
<li> You will receive another email with the subject: #{%Q("Reset password instructions",  instructing you to click on "Change my password")}</li>
<ul><li>You will be prompted to enter #{%Q("New password" and "Confirm password")}</li>
<li> Click on #{%Q("Change my password")}</li>
</ul></ol>
<p>  You'll then be logged into your account.</p>
<p>If you have any questions or experience any difficulties in accessing the system, please contact #{DEFAULT_MAILER_SENDER}</p>
BODY
  end
end
