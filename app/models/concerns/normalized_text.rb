module NormalizedText
  extend ActiveSupport::Concern

  # Downcase, strip all whitespace, then remove every "test" (repeated); blank -> nil.
  def self.call(value)
    return if value.nil?

    result = value.to_s.downcase.gsub(/\s+/, "")
    result = result.gsub("test", "") while result.include?("test")
    result.presence
  end

  class_methods do
    def normalizes_text(*names)
      normalizes(*names, with: ->(value) { NormalizedText.call(value) })
    end
  end
end
