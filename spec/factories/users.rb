# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username { Faker::Name.name }
    email { Faker::Internet.email }
    password 'secret'
    password_confirmation 'secret'
    activated true
    activated_at { Time.zone.now }

    factory :inactivated_user do
      activated false
      activated_at nil
    end
  end
end
