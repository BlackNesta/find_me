# frozen_string_literal: true

require "rails_helper"

RSpec.describe Brand, type: :model do
  subject(:brand) { build(:brand) }

  it "has a valid factory" do
    expect(brand).to be_valid
  end

  describe "associations" do
    it { is_expected.to have_many(:brand_users).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:brand_users) }
    it { is_expected.to have_many(:settings).dependent(:destroy) }
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

    it "measures length after normalization" do
      expect(build(:brand, name: "  #{'a' * 255}  ")).to be_valid
    end
  end

  describe "name presence" do
    it "is invalid when name is nil" do
      brand.name = nil
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("can't be blank")
    end

    it "is invalid when name is blank" do
      brand.name = "   "
      expect(brand).not_to be_valid
    end

    it "is invalid when name normalizes to blank" do
      brand.name = "Test"
      expect(brand).not_to be_valid
      expect(brand.errors[:name]).to include("can't be blank")
    end
  end

  describe "name normalization" do
    it "downcases the name" do
      expect(create(:brand, name: "Apple").name).to eq("apple")
    end

    it "removes all whitespace" do
      expect(create(:brand, name: "  Coca   Cola ").name).to eq("cocacola")
    end

    it "removes every 'test' occurrence (case-insensitive, repeated, across spaces)" do
      expect(create(:brand, name: "TestCocaTest").name).to eq("coca")
      expect(create(:brand, name: "tetestst Inc").name).to eq("inc")
      expect(create(:brand, name: "Te St Acme").name).to eq("acme")
    end
  end

  describe "name uniqueness" do
    before { create(:brand, name: "Apple") }

    it "rejects an identical name" do
      duplicate = build(:brand, name: "apple")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end

    it "rejects a name that normalizes to an existing one" do
      expect(build(:brand, name: "  APPLE  ")).not_to be_valid
      expect(build(:brand, name: "aTESTpple")).not_to be_valid
    end

    it "allows a distinct name" do
      expect(build(:brand, name: "Google")).to be_valid
    end
  end

  describe "uniqueness on update" do
    it "allows a record to be saved with its own unchanged name" do
      brand = create(:brand, name: "Apple")
      brand.name = "Apple"
      expect(brand).to be_valid
    end

    it "rejects updating into another record's name" do
      create(:brand, name: "Apple")
      other = create(:brand, name: "Google")
      other.name = "  APPLE  "
      expect(other).not_to be_valid
      expect(other.errors[:name]).to include("has already been taken")
    end
  end

  describe "database-level uniqueness" do
    before { create(:brand, name: "Apple") }

    it "enforces the unique index even when validations are skipped" do
      duplicate = build(:brand, name: "apple")
      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "rejects a case-insensitive duplicate at the DB layer (bypassing the model)" do
      now = Time.current
      expect {
        Brand.insert_all!([ { name: "apple", created_at: now, updated_at: now } ])
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
