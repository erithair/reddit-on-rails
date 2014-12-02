# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  email             :string(255)
#  password_digest   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  links_count       :integer          default(0), not null
#  comments_count    :integer          default(0), not null
#

class User < ActiveRecord::Base

  attr_reader :remember_token
  attr_accessor :activation_token, :reset_token

  has_many :links
  has_many :comments
  has_many :votes

  has_secure_password

  validates :username, presence: true, length: { in: 4..50 }
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, length: {  minimum: 6 }

  before_save { email.downcase! }
  before_create :create_activation_digest


  # user action methods

  def vote(options)
    # treat invalid param as an up vote.
    options[:up] = 1 unless options[:up] == -1
    vote = votes.build(options)
    vote.save
  end

  def comment(link, params)
    comment = comments.build(params.merge(link: link))
    comment.save
  end


  # email sending methods

  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end


  # other methods

  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  def create_reset_digest
    self.reset_token = new_token
    update_columns(reset_digest: digest(reset_token), reset_sent_at: Time.zone.now)
  end

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
    update_columns(activated: true, activated_at: Time.zone.now)
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
