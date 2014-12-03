# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  up           :integer
#  created_at   :datetime
#  updated_at   :datetime
#  votable_id   :integer
#  votable_type :string(255)
#
# Indexes
#
#  index_votes_on_user_id                                  (user_id)
#  index_votes_on_user_id_and_votable_id_and_votable_type  (user_id,votable_id,votable_type) UNIQUE
#  index_votes_on_votable_id_and_votable_type              (votable_id,votable_type)
#

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true,  dependent: :destroy

  validates :up,    inclusion: { in: [1, -1] }
  validates :user,  presence: true
  validates :votable,  presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  # update the rank after voting
  after_create do |vote|
    link_or_comment = vote.votable
    link_or_comment.rank += up
    link_or_comment.save!
  end
end
