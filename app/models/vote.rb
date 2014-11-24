class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true,  dependent: :destroy

  validates :up,    inclusion: { in: [1, -1] }
  validates :user,  presence: true
  validates :votable,  presence: true
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
end
