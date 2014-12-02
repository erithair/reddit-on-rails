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

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true,  dependent: :destroy

  validates :up,    inclusion: { in: [1, -1] }
  validates :user,  presence: true
  validates :votable,  presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
