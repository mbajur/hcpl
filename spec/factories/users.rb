FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
  end
end
