class Comment < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :link

  validates :content, presence: true
  validates :user, presence: true
  validates :link, presence: true
end
