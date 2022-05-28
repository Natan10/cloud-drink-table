FactoryBot.define do
  factory :user, class: 'User::User' do |u|
    u.username { Faker::Name.name }
    u.email { Faker::Internet.email }
    u.password { "123456" }
    u.password_confirmation { "123456" }
    u.photo {nil}
  end
end
