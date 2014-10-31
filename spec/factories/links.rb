# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    url { Faker::Internet.url }
    title { Faker::Lorem.sentence }
    user

    after(:build) do |link|
      link.user.links << link
    end
  end
end
