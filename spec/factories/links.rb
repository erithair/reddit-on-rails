# == Schema Information
#
# Table name: links
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  url            :string(255)
#  title          :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  comments_count :integer          default(0), not null
#  rank           :integer          default(0), not null
#
# Indexes
#
#  index_links_on_user_id  (user_id)
#

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
