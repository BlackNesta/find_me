class Brand < ApplicationRecord
  include NormalizedText

  normalizes_text :name

  has_many :brand_users, dependent: :destroy
  has_many :users, through: :brand_users
  has_many :settings, as: :settable, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
end
