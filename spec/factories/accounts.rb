FactoryBot.define do
  factory :account do
    total_account { Faker::Number.number(digits: 3) }
    status { [:open,:closed].sample }
    description { Faker::Restaurant.name }
    user 
  end
end
