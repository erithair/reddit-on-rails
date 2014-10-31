class User < ActiveRecord::Base

  validates :username, presence: true, length: { in: 4..50 }
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, length: {  minimum: 6 }

  has_secure_password

  has_many :links

  before_save { email.downcase! }
end
