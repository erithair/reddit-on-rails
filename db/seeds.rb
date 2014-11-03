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


img_urls = ["http://b.thumbs.redditmedia.com/A_h0y5Lg1cowmvUKlrXPm3BBoR46JRcsAxk5w3ssHgI.jpg",
 "http://b.thumbs.redditmedia.com/3HkoBnNT0XoXTIiBTv5oSYnOLT4J9pJLsR16xMuYmlA.jpg",
 "http://b.thumbs.redditmedia.com/68eDdNYiaSGTWU6Dcu-OXmm4e4fKtS7xDj3OA-SmeuM.jpg",
 "http://b.thumbs.redditmedia.com/_H5Bog4h9Nja2VMhHd1ruQwYsScXjFgbTlkOJBJrKsM.jpg",
 "http://b.thumbs.redditmedia.com/yebH-xdOBpDA8UQ3bX1wdutLyxHE9TK5gldZtKYseio.jpg",
 "http://b.thumbs.redditmedia.com/NMcvCPgkceukFsOn7vioAaAjZfFc3Gbp9uaYbJp5cio.jpg",
 "http://b.thumbs.redditmedia.com/GTr-pVZiXUF4e4QTIFFSOtupIe0aQekDMTAr3u4Da6w.jpg",
 "http://b.thumbs.redditmedia.com/u9cD9KiJb8wLZ2YHf5_SL8SfLxHU4kdF0QMmjeL88Og.jpg",
 "http://b.thumbs.redditmedia.com/5u8F4PETarCGRbhFgMBAoVdvJ6AcBYFG6b5DEH7ZuYc.jpg",
 "http://b.thumbs.redditmedia.com/bJoZhXIVqtXaoM73qR6uCenppu6p_xK7ThqjHxyWZqg.jpg",
 "http://b.thumbs.redditmedia.com/v8JgShW0evIkhgvyTba_l_TsHPYXTeOKFCh4A3Rj_vw.jpg",
 "http://b.thumbs.redditmedia.com/TZb_liZqb2VSq7O4Nhtys--VRMy2qi-k12v2nBxZmtM.jpg",
 "http://b.thumbs.redditmedia.com/2H9UrkkmVuVpABvHhyaprXbew-2BJhZ6sg8PsZDxk-I.jpg",
 "http://b.thumbs.redditmedia.com/v5w9hEK2heNKNPFtRmb_p4eS3BHidG3SZceqX8nCmHA.jpg",
 "http://b.thumbs.redditmedia.com/3ID1q2wcF8xNVLulJ3xtAw0SEkot3dPfs6oH_cnuG-k.jpg",
 "http://a.thumbs.redditmedia.com/al9tO0LDcpNoZE57IH2xJ80233Zk_e5BOV3oEKvAuy4.jpg",
 "http://a.thumbs.redditmedia.com/o8J-jM5ewE6-2ZtOTBcdwi5Gwp7A5YcG49zysMMZla0.jpg",
 "http://b.thumbs.redditmedia.com/k0OApEtgkVcoiPcK7r4ZwROCrf0VmIxmNvZaeuXIxhM.jpg",
 "http://b.thumbs.redditmedia.com/3B1I9bjGzxMAfPr0Vz_gqemY_-gQj1rAe9uXkIYYm_g.jpg",
 "http://b.thumbs.redditmedia.com/7g7QGuALFGTRno9XFTPcxO3I8K7WlQSbZKiwaJ_3lSk.jpg",
 "http://pixel.redditmedia.com/pixel/of_defenestration.png?hash=adblock0e31bc319d5b5882b0cddf147f4ce1da5ac9c731&id=adblock&random=3524888968095183.5",
 "http://www.redditstatic.com/kill.png"]

# create some links
30.times do
  user = random_user.call

  user.links.create!(
    url: img_urls.sample,
    title: Faker::Lorem.sentence)
end
