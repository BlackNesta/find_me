class Brand < ApplicationRecord
  strip_attributes only: :name, collapse_spaces: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 255 }
end
