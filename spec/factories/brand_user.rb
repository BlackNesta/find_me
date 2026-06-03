FactoryBot.define do
  factory :brand_user do
    association :brand
    association :user
  end
end
