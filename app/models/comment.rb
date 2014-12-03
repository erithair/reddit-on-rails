# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  link_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  rank       :integer          default(0), not null
#
# Indexes
#
#  index_comments_on_link_id  (link_id)
#  index_comments_on_user_id  (user_id)
#

class Comment < ActiveRecord::Base
  scope :latest,  -> { order(created_at: :desc) }
  scope :rank,    -> { order(rank: :desc) }

  belongs_to :user, counter_cache: true
  belongs_to :link, dependent: :destroy, counter_cache: true
  has_many :votes, as: :votable

  validates :content, presence: true
  validates :user, presence: true
  validates :link, presence: true

  def self.order_by(order)
    [:latest, :rank].include?(order) ? send(order) : send(:latest)
  end
end
