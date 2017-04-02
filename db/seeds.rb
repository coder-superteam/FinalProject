# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'

# Create 5 random users
password = 'pass123'
1.upto(5) do |i|
  User.create(
  	name: "user-#{i}",
    email: "user-#{i}@mail.com",
    password: password,
    password_confirmation: password
  )
end

User.create(
  	name: "Google Translator",
    email: "googlebot@admin.com",
    password: password,
    password_confirmation: password
  )

User.create(
    name: "Bing Translator",
    email: "bingbot@admin.com",
    password: password,
    password_confirmation: password
  )

# Generate Post
5.times do |i|
  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  answerer1 = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  answerer2 = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  post = Post.create(
    user_id: user.id,
    title: 'Please help me translate this',
    language: '3',
    body: Faker::Lorem.paragraph,
    created_at: Faker::Time.between(DateTime.now - Faker::Number.between(1, 100), DateTime.now),
    vote_number: Faker::Number.between(-10, 10)
    )
  reply1 = Reply.create(
      user_id: answerer1.id,
      post_id: post.id,
      body: Faker::Lorem.paragraph,
      created_at: Faker::Time.between(DateTime.now - Faker::Number.between(1, 3), DateTime.now),
      vote_number: Faker::Number.between(-10, 10)
    )
  reply2 = Reply.create(
      user_id: answerer2.id,
      post_id: post.id,
      body: Faker::Lorem.paragraph,
      created_at: Faker::Time.between(DateTime.now - Faker::Number.between(3, 5), DateTime.now),
      vote_number: Faker::Number.between(-10, 10)
    )
end

5.times do |i|
  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  answerer1 = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  answerer2 = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
    )
  
  post = Post.create(
    user_id: user.id,
    title: 'Please help me translate this',
    language: '3',
    body: Faker::Lorem.paragraph,
    remote_image_url: 'http://lorempixel.com/g/400/200/',
    keywords: Faker::Lorem.paragraph,
    created_at: Faker::Time.between(DateTime.now - Faker::Number.between(1, 100), DateTime.now),
    vote_number: Faker::Number.between(-10, 10)
    )
  reply1 = Reply.create(
      user_id: answerer1.id,
      post_id: post.id,
      body: Faker::Lorem.paragraph,
      created_at: Faker::Time.between(DateTime.now - Faker::Number.between(1, 3), DateTime.now),
      vote_number: Faker::Number.between(-10, 10)
    )
  reply2 = Reply.create(
      user_id: answerer2.id,
      post_id: post.id,
      body: Faker::Lorem.paragraph,
      created_at: Faker::Time.between(DateTime.now - Faker::Number.between(3, 5), DateTime.now),
      vote_number: Faker::Number.between(-10, 10)
    )
end