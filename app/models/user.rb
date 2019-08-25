class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable

  validates :fullname, presence: true, length: {maximum: 50}

  has_many :rooms
  has_many :reservations
  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"
  has_many :notifications

  has_one :setting
  after_create :add_setting

  def add_setting
    Setting.create(user: self, enable_sms: true, enable_email: true)
  end

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first

    if user 
      if !user.provider
        user.update(uid: auth.uid, provider: auth.provider, image: auth.info.image)
      end
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.fullname = auth.info.name   
        user.image = auth.info.image 
        user.uid = auth.uid
        user.provider = auth.provider

        user.skip_confirmation!
      end
    end
  end

  def generate_pin
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    self.save
  end

  def send_pin
    require 'twilio-ruby'

    # put your own credentials here
    account_sid = Rails.application.credentials[:twilio][:access_account_sid]
    auth_token = Rails.application.credentials[:twilio][:access_auth_token]
    
    # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.api.account.messages.create(
      from: '+33755537138',
      to: self.phone_number,
      body: "Your pin is #{self.pin}"
    )
  end

  def verify_pin(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end

  def is_active_host
    !self.merchant_id.blank?
  end
end
