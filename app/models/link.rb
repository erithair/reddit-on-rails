class Link < ActiveRecord::Base
  scope :latest,        -> { order(created_at: :desc) }
  scope :top,           -> { joins(:votes).group('links.id').order('SUM(votes.up) DESC') }

  belongs_to :user
  has_many :comments
  has_many :votes, as: :votable

  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }
  validates :title, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  # show 20 links every page
  self.per_page = 20

  def rank
    votes.sum(:up)
  end
end
