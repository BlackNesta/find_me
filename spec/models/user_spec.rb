# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it "has a valid factory" do
    expect(user).to be_valid
  end

  describe "associations" do
    it { is_expected.to have_many(:brand_users).dependent(:destroy) }
    it { is_expected.to have_many(:brands).through(:brand_users) }

    it "exposes the brands a user belongs to" do
      user = create(:user)
      brand_a = create(:brand, name: "Apple")
      brand_b = create(:brand, name: "Google")
      create(:brand_user, user: user, brand: brand_a)
      create(:brand_user, user: user, brand: brand_b)

      expect(user.brands).to contain_exactly(brand_a, brand_b)
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:email).is_at_most(255) }
  end

  describe "email format" do
    it "accepts a well-formed email" do
      expect(build(:user, email: "jane.doe@example.com")).to be_valid
    end

    it "rejects a malformed email" do
      expect(build(:user, email: "not-an-email")).not_to be_valid
    end

    it "rejects an email left malformed after cutting 'test'" do
      user = build(:user, email: "test@test.com") # -> "@.com"
      expect(user).not_to be_valid
      expect(user.email).to eq("@.com")
    end
  end

  describe "email uniqueness" do
    before { create(:user, email: "jane@example.com") }

    it "rejects an identical email" do
      expect(build(:user, email: "jane@example.com")).not_to be_valid
    end

    it "rejects an email that normalizes to an existing one" do
      expect(build(:user, email: "  JANE@example.com  ")).not_to be_valid
    end

    it "allows a distinct email" do
      expect(build(:user, email: "john@example.com")).to be_valid
    end
  end

  describe "name presence after normalization" do
    it "is invalid when first_name normalizes to blank" do
      user.first_name = "Test"
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("can't be blank")
    end

    it "is invalid when last_name normalizes to blank" do
      user.last_name = "  "
      expect(user).not_to be_valid
    end
  end

  describe "field normalization" do
    it "downcases and removes all whitespace from names" do
      user = create(:user, first_name: "  Jane  ", last_name: "Van  Doe")
      expect(user.first_name).to eq("jane")
      expect(user.last_name).to eq("vandoe")
    end

    it "downcases the email" do
      expect(create(:user, email: "Jane.Doe@Example.com").email).to eq("jane.doe@example.com")
    end

    it "cuts 'test' from names" do
      user = create(:user, first_name: "TestJane", last_name: "DoeTest")
      expect(user.first_name).to eq("jane")
      expect(user.last_name).to eq("doe")
    end
  end

  describe "database-level email uniqueness" do
    before { create(:user, email: "jane@example.com") }

    it "enforces the unique index even when validations are skipped" do
      duplicate = build(:user, email: "jane@example.com")
      expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "rejects a case-insensitive duplicate email at the DB layer (bypassing the model)" do
      now = Time.current
      expect {
        User.insert_all!([{ first_name: "ada", last_name: "lovelace", email: "JANE@example.com", created_at: now, updated_at: now }])
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
