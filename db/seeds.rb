# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "shantti_y",
             email_num: "hammpilot@gmail.com",
             password: "d1am0n6s",
             password_confirmation: "d1am0n6s",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

 User.create!(name: "example_user",
              email_num: "example@raistutorial.org",
              password: "d1am0n6s",
              password_confirmation: "d1am0n6s",
              activated: true,
              activated_at: Time.zone.now)

99.times do |n|
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
