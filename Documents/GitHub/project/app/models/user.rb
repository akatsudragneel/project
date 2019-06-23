require "open-uri" # Needed for google calendar
class User < ActiveRecord::Base # This model handles everything realted to users.Fetcing of data from google account as well as facebook or google authentication is done in this model.

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable  
  devise :invitable, :database_authenticatable, :registerable, :confirmable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable,:validate_on_invite => true 
          # Invitable module is added as invitations is to be send to users by admin
  has_many :memberships, :dependent => :destroy
  has_many :groups, through: :memberships
  has_many :posts
  has_many :events
  has_many :contacts
  acts_as_voter        
  belongs_to :role
  belongs_to :group
  
  NAME_REGEX = /\A[^0-9`!@#\$%\^&*+_=]+\z/
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i         
 
  validates :name, presence: true 
  validates_format_of :name, :with => NAME_REGEX, message: "Name can't be blank"  
  validates :email, presence: true
  validates_format_of :email, :with => EMAIL_REGEX , message: "Please enter a valid email id"  
  before_save :assign_role # By default role will be regular if not specified 
  
  def after_confirmation   # Send welcome mail after user is successfully registered
    send_user_mail
  end           

  def accept_invitation!   # when invite is accepted then admin is informed reagrding this
    send_invite_mail
    super
  end

  def assign_role          # for assigning role to the newly registered user which is regular by default. 
    self.role = Role.find_by name: "Regular" if self.role.nil? #Access to any role is controlled by CanCan in ability.rb
  end

  def admin?
    self.role.name == "Admin"
  end

  def superadmin?
    self.role.name == "Superadmin"
  end

  def regular?
    self.role.name == "Regular"
  end

  def active_for_authentication? 
    super && approved? 
  end 
  
  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super 
    end 
  end

  def self.from_omniauth(auth)              # getting info from user social account and storing them in table
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.nickname || auth.info.name
      user.skip_confirmation!
      @user = user               # if user is following social account registration,then email confirmation is ignonred 
    end 
  end

  def self.new_with_session(params, session)         #creating session for an existing user
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
      user.email = data["email"] if user.email.blank? and params[:provider] == 'facebook'
      user.attributes = params
      user.valid?
      end
    else
      super
    end
  end

  def password_required?               # password validation is avoided as authentication is done using registered accounts
    super && provider.blank?
  end

  def update_with_password(params, *options)        # to handle field which need current password in order to update to a new password
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end  

  def self.find_for_google_oauth2(oauth, signed_in_resource=nil)
    credentials = oauth.credentials
    data = oauth.info
    user = User.where(email: data["email"]).first
    if user
      user.token = credentials.token
    end
    unless user
      user = User.new({
      name: data["name"],
      email: data["email"],
      password: Devise.friendly_token[0,20],
      token: credentials.token
     })
    end
    user.skip_confirmation!
    user.save!
    user.get_google_calendars  
    user
  end

  def get_google_calendars
    url = "https://www.googleapis.com/calendar/v3/users/me/calendarList?access_token=#{token}"
    response = open(url)
    json = JSON.parse(response.read)
    calendars = json["items"]
    calendars.each { |cal| get_events_for_calendar(cal) }
  end

  def get_events_for_calendar(cal)
    url = "https://www.googleapis.com/calendar/v3/calendars/#{URI.encode(cal["id"])}/events?access_token=#{token}"
    response = open(url)
    json = JSON.parse(response.read)
    my_events = json["items"]
    my_events.each do |event|
      name = event["summary"] || "no name"
      creator = event["creator"] ? event["creator"]["email"] : nil
      start = event["start"] ? event["start"]["dateTime"] : nil
      status = event["status"] || nil
      link = event["htmlLink"] || nil
      calendar = cal["summary"] || nil
      events.create(name: name,
                    creator: creator,
                    status: status,
                    start: start,
                    link: link,
                    calendar: calendar
                    )
    end
  end

  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    if !recoverable.approved?
      recoverable.errors[:base] << I18n.t("devise.failure.not_approved")
    elsif recoverable.persisted?
      recoverable.send_reset_password_instructions
    end
    recoverable
  end

  private
    def send_user_mail                        # sending welcome mail to newly registered user
      UserMailer.send_welcome_email(self).deliver_later
    end

    def send_invite_mail                      # sending mail to admin regarding acceptance of his mail
      UserMailer.send_admin_mail(self).deliver_later
    end
end