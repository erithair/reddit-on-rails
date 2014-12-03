# == Schema Information
#
# Table name: links
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  url            :string(255)
#  title          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  comments_count :integer          default(0), not null
#

class Link < ActiveRecord::Base
  scope :latest,  -> { order(created_at: :desc) }
  scope :rank,    -> { order(rank: :desc) }
  scope :hot,     -> { order(comments_count: :desc) }

  belongs_to :user, counter_cache: true
  has_many :comments
  has_many :votes, as: :votable

  validates :url, presence: true, format: { with: URI::regexp(%w[http https]) }
  validates :title, presence: true, length: { maximum: 200 }
  validates :user, presence: true

  # show 20 links every page
  self.per_page = 20

  def self.order_by(order)
    [:latest, :rank, :hot].include?(order) ? send(order) : send(:latest)
  end
end
