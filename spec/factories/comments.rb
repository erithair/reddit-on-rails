# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    content { Faker::Lorem.paragraph(2, true, 4) }
    user
    link

    after(:build) do |comment|
      comment.user.comments << comment
      comment.link.comments << comment
    end
  end
end
