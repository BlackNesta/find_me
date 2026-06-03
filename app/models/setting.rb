class Setting < ApplicationRecord
  belongs_to :settable, polymorphic: true

  validates :key,
            length: { maximum: 255 },
            uniqueness: { scope: %i[settable_type settable_id], case_sensitive: false },
            allow_blank: true
end
