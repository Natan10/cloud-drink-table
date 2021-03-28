FactoryBot.define do
  factory :consumer do
    name { Faker::Name.name }
    total_consumed { Faker::Number.number(digits: 3) }
    account
  end
end
