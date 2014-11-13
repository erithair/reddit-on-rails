class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :link, dependent: :destroy

  validates :up,    inclusion: { in: [true, false] }
  validates :user,  presence: true
  validates :link,  presence: true
  validates :user_id, uniqueness: { scope: :link_id }
end
