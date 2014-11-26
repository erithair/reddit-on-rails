class Comment < ActiveRecord::Base
  scope :latest,  -> { order(created_at: :desc) }
  scope :rank,    -> { joins(:votes).group('comments.id').order('SUM(votes.up) DESC') }

  belongs_to :user, counter_cache: true
  belongs_to :link, dependent: :destroy, counter_cache: true
  has_many :votes, as: :votable

  validates :content, presence: true
  validates :user, presence: true
  validates :link, presence: true

  def self.order_by(order)
    [:latest, :rank].include?(order) ? send(order) : send(:latest)
  end

  def rank
    votes.sum(:up)
  end
end
