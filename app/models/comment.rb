class Comment < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  belongs_to :user
  belongs_to :link, dependent: :destroy
  has_many :votes, as: :votable

  validates :content, presence: true
  validates :user, presence: true
  validates :link, presence: true

  def rank
    votes.sum(:up)
  end
end
