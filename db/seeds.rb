# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Seeds for users
User.create!(name: "shantti_y",
             email_num: "hammpilot@gmail.com",
             password: "d1am0n6s",
             password_confirmation: "d1am0n6s",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

 User.create!(name: "example_user",
              email_num: "example@railstutorial.org",
              password: "d1am0n6s",
              password_confirmation: "d1am0n6s",
              activated: true,
              activated_at: Time.zone.now)

98.times do |n|
  name = Faker::Name.name
  email_num = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
               email_num: email_num,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

# Seeds for tweets
users = User.order(:id)
users.each do |user|
  20.times do |n|
    r = Random.new
    created_at = Time.zone.now - r.rand(24*60*60)
    user.tweets.create!(content: Faker::Lorem.sentence(3), created_at: created_at)
  end
end

users.each do |user|
  r = Random.new
  r.rand(50).times do |n|
    user.follow(User.find(r.rand(99) + 1))
  end
end
