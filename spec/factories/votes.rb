# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote, aliases: [:up_vote] do
    up true
    user
    link

    after(:build) do |vote|
      vote.user.votes << vote
      vote.link.votes << vote
    end

    factory :down_vote do
      up false
    end
  end
end
