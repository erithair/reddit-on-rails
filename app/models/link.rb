class Link < ActiveRecord::Base
  default_scope { order(created_at: :desc) }

  # show 20 links every page
  self.per_page = 20

  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }
  validates :title, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  belongs_to :user
  has_many :comments
  has_many :votes

  def rank
    votes.where(up: true).count - votes.where(up: false).count
  end
end
