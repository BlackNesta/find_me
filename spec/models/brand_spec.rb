# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brand, type: :model do
  subject(:brand) { build(:brand) }

  it "has a valid factory" do
    expect(brand).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
  end

  describe "name length" do
    it "accepts a name at the 255-character limit" do
      expect(build(:brand, name: "a" * 255)).to be_valid
    end

    it "rejects a name longer than 255 characters" do
      brand = build(:brand, name: "a" * 256)
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("is too long (maximum is 255 characters)")
    end

    it "measures length after stripping whitespace" do
      expect(build(:brand, name: "  #{'a' * 255}  ")).to be_valid
    end
  end

  describe "name presence" do
    it "is invalid when name is nil" do
      brand.name = nil
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("can't be blank")
    end

    it "is invalid when name is an empty string" do
      brand.name = ""
      expect(brand).not_to be_valid
    end

    it "is invalid when name is only whitespace" do
      brand.name = "   "
      expect(brand).not_to be_valid
    end
  end

  describe "name uniqueness" do
    before { create(:brand, name: "Apple") }

    it "rejects an identical name" do
      duplicate = build(:brand, name: "Apple")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end

    it "rejects a name that differs only in case" do
      expect(build(:brand, name: "apple")).not_to be_valid
      expect(build(:brand, name: "APPLE")).not_to be_valid
    end

    it "allows a distinct name" do
      expect(build(:brand, name: "Google")).to be_valid
    end
  end

  describe "name normalization" do
    it { is_expected.to strip_attribute(:name).collapse_spaces }

    it "strips leading and trailing whitespace before saving" do
      brand = create(:brand, name: "  Apple  ")
      expect(brand.name).to eq("Apple")
    end

    it "collapses repeated inner whitespace" do
      brand = create(:brand, name: "App\t  le")
      expect(brand.name).to eq("App le")
    end

    it "treats whitespace-padded names as duplicates" do
      create(:brand, name: "Apple")
      expect(build(:brand, name: "  Apple  ")).not_to be_valid
    end

    it "is invalid when name collapses to blank" do
      brand = build(:brand, name: "   ")
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("can't be blank")
    end
  end

  describe "uniqueness on update" do
    it "allows a record to be saved with its own unchanged name" do
      brand = create(:brand, name: "Apple")
      brand.name = "Apple"
      expect(brand).to be_valid
    end

    it "rejects updating into another record's name (case/space-insensitive)" do
      create(:brand, name: "Apple")
      other = create(:brand, name: "Google")
      other.name = "  apple  "
      expect(other).not_to be_valid
      expect(other.errors[:name]).to include("has already been taken")
    end
  end

  describe "database-level uniqueness" do
    before { create(:brand, name: "Apple") }

    it "enforces the case-insensitive unique index even when validations are skipped" do
      duplicate = build(:brand, name: "apple")
      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
