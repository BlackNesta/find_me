FactoryBot.define do
  factory :setting do
    association :settable, factory: :brand_user
    sequence(:key) { |n| "key_#{n}" }
    value { "value" }
  end
end
