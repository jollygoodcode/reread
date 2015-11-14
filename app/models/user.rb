class User < ActiveRecord::Base

  has_one  :setting
  has_many :pockets

  validates_presence_of :username, :token

  delegate :email,
           :time_zone,
           :send_at,
           :schedule,
           :number,
           :can_send_now?,
           to: :setting

  before_create :generate_remember_token

  def self.find_or_create_with(oauth_info)
    User
      .where(username: oauth_info[:username])
      .first_or_create!(token: oauth_info[:token])
  end

  def token=(value)
    encrypted_token = crypt.encrypt_and_sign(value)
    write_attribute(:token, encrypted_token)
  end

  def token
    encrypted_token = read_attribute(:token)
    crypt.decrypt_and_verify(encrypted_token) unless encrypted_token.nil?
  end

  private

    def generate_remember_token
      self.remember_token = SecureRandom.hex(20)
    end

    def crypt
      ActiveSupport::MessageEncryptor.new(
        Rails.application.secrets.secret_key_base
      )
    end
end
