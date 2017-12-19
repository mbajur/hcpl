FactoryBot.define do
  factory :post do
    title Faker::Lorem.sentence

    user
  end
end
