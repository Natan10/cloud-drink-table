FactoryBot.define do
  factory :account, class: '::Account::Account' do |a|
    a.total_account { Faker::Number.number(digits: 4) }
    a.status { [:open, :closed].sample }
    a.description { Faker::Restaurant.name }
    a.user
  end
end
