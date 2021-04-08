FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    quantity { rand(0..50) }
    price_cents { Faker::Number.number(digits: 2) }
    consumer 
  end
end
