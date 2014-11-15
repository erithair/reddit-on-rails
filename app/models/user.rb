class User < ActiveRecord::Base

  attr_reader :remember_token
  attr_accessor :activation_token

  validates :username, presence: true, length: { in: 4..50 }
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, length: {  minimum: 6 }

  has_secure_password

  has_many :links
  has_many :comments
  has_many :votes

  before_save { email.downcase! }
  before_create :create_activation_digest

  def remember
    @remember_token = new_token
    update_attribute(:remember_digest, digest(@remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute,  token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  private

  def new_token
    SecureRandom.urlsafe_base64
  end

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def create_activation_digest
    self.activation_token = new_token
    self.activation_digest = digest(activation_token)
  end

end
