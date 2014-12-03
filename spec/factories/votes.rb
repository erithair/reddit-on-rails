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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link_vote, class: 'Vote' do
    up { [1, -1].sample }
    user
    association :votable, factory: :link

    after(:build) do |vote|
      vote.user.votes << vote
      vote.votable.votes << vote
    end

    factory :comment_vote, class: 'Vote' do
      up { [1, -1].sample }
      user
      association :votable, factory: :comment
    end
  end
end
