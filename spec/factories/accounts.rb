FactoryBot.define do
  factory :account do
    total_account { Faker::Number.number(digits: 4) }
    status { [:open, :closed].sample }
    description { Faker::Restaurant.name }
    user
  end
end
