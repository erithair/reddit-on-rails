class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :link

  validates :content, presence: true
  validates :user, presence: true
  validates :link, presence: true
end
