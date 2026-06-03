class User < ApplicationRecord
  include NormalizedText

  normalizes_text :first_name, :last_name, :email

  has_many :brand_users, dependent: :destroy
  has_many :brands, through: :brand_users

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    email: { allow_blank: true },
                    length: { maximum: 255 }
end
