# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    up { [1, -1].sample }
    user
    link

    after(:build) do |vote|
      vote.user.votes << vote
      vote.link.votes << vote
    end

    factory :up_vote do
      up 1
    end

    factory :down_vote do
      up -1
    end
  end
end
