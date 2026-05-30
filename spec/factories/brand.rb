FactoryBot.define do
  factory :brand do
    name { Faker::Company.unique.name }
  end
end
