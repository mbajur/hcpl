FactoryBot.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    sequence(:username) { |n| "user#{n}" }
    active true
    approved true
    confirmed true
  end
end
