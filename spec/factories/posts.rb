FactoryBot.define do
  factory :post do
    sequence(:title) { Faker::Lorem.sentence }

    user
  end
end
