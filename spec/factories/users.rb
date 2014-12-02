# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string(255)
#  email             :string(255)
#  password_digest   :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  remember_digest   :string(255)
#  activation_digest :string(255)
#  activated         :boolean
#  activated_at      :datetime
#  reset_digest      :string(255)
#  reset_sent_at     :datetime
#  links_count       :integer          default(0), not null
#  comments_count    :integer          default(0), not null
#

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
