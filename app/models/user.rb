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
# Indexes
#
#  index_users_on_email  (email) UNIQUE
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

  def vote(object, up)
    # treat invalid param as an up vote.
    up = up.to_i
    up = 1 unless up == -1

    vote = votes.build(votable_id: object.id, votable_type: object.class.to_s, up: up)
    vote.save
  end

  def comment(link, comment)
    comment.link = link
    comment.user = self
    comment.save
  end

  def vote_kind(object)
    if vote = Vote.find_by(user_id: self, votable_id: object, votable_type: object.class.to_s)
      vote.up
    end
  end


  # email sending methods

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
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
