class BrandUser < ApplicationRecord
  belongs_to :brand, counter_cache: :users_count
  belongs_to :user

  has_one :setting, as: :settable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :brand_id, message: "is already added to this brand" }
end
