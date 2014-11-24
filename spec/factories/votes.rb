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
