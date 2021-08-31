# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create user 

require 'faker'

puts "create users"
5.times do |number|
  User.create({ 
    username: Faker::Name.name,
    email: "user#{number}@email.com",
    password: "123456",
    password_confirmation: "123456",
   })
end

puts "create restaurants"
5.times do |number|
  res = Restaurant.create(name: Faker::Restaurant.name)

  [1,3,5,7].sample.times do |number|
    Product.create({
      name: Faker::Food.dish,
      description: Faker::Food.description,
      price: ["12.80","40.80","100.0","2.80"].sample,
      restaurant_id: res.id
    })
  end
end
