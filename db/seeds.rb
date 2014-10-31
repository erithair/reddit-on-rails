# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(username: 'admin',
 email: 'admin@example.com',
 password: 'foobar',
 password_confirmation: 'foobar')


# create 10 users
10.times do
  User.create!(
    username: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'secret',
    password_confirmation: 'secret')
end

# select random user
user_count = 10
users = User.count > user_count ? User.take(user_count) : User.all
random_user = -> { users[rand(user_count)] }

# create some links
30.times do
  user = random_user.call

  user.links.create!(
    url: Faker::Internet.url,
    title: Faker::Lorem.sentence)
end
