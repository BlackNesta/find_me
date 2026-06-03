# frozen_string_literal: true

require "rails_helper"

RSpec.describe Setting, type: :model do
  subject(:setting) { build(:setting) }

  it "has a valid factory" do
    expect(setting).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to(:settable) }

    it "can belong to a brand-user membership" do
      brand_user = create(:brand_user)
      setting = create(:setting, settable: brand_user)
      expect(setting.settable).to eq(brand_user)
    end

    it "can belong to a brand directly" do
      brand = create(:brand)
      setting = create(:setting, settable: brand)
      expect(setting.settable).to eq(brand)
    end
  end

  describe "validations" do
    it { is_expected.to validate_length_of(:key).is_at_most(255) }

    it "allows a blank key and value" do
      expect(build(:setting, key: nil, value: nil)).to be_valid
    end

    it "rejects a duplicate key for the same owner" do
      brand = create(:brand)
      create(:setting, settable: brand, key: "theme")
      expect(build(:setting, settable: brand, key: "theme")).not_to be_valid
    end

    it "allows the same key for different owners" do
      create(:setting, settable: create(:brand), key: "theme")
      expect(build(:setting, settable: create(:brand), key: "theme")).to be_valid
    end
  end

  describe "key and value are not normalized" do
    it "keeps the original casing and 'test' substring" do
      setting = create(:setting, key: "TestKey", value: "Test Value")
      expect(setting.key).to eq("TestKey")
      expect(setting.value).to eq("Test Value")
    end
  end
end
