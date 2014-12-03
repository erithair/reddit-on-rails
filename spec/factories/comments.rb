# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text
#  user_id    :integer
#  link_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  rank       :integer          default(0), not null
#
# Indexes
#
#  index_comments_on_link_id  (link_id)
#  index_comments_on_user_id  (user_id)
#

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
