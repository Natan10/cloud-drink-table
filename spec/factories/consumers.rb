FactoryBot.define do
  factory :consumer do
    name { Faker::Name.name }
    total_consumed { Faker::Number.number(digits: 4) }
    account
  end
end
