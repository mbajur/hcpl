FactoryBot.define do
  factory :tag do
    sequence(:name) { Faker::Lorem.word }
  end
end
