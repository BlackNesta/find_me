# frozen_string_literal: true

require "rails_helper"

RSpec.describe BrandUser, type: :model do
  subject(:brand_user) { build(:brand_user) }

  it "has a valid factory" do
    expect(brand_user).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to(:brand).counter_cache(:users_count) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one(:setting).dependent(:destroy) }
  end

  describe "one membership per (user, brand)" do
    let(:brand) { create(:brand) }
    let(:user) { create(:user) }

    before { create(:brand_user, brand: brand, user: user) }

    it "rejects a duplicate user for the same brand" do
      duplicate = build(:brand_user, brand: brand, user: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("is already added to this brand")
    end

    it "allows the same user on a different brand" do
      expect(build(:brand_user, brand: create(:brand, name: "Other"), user: user)).to be_valid
    end

    it "enforces the unique index at the DB layer (bypassing the model)" do
      now = Time.current
      expect {
        BrandUser.insert_all!([ { brand_id: brand.id, user_id: user.id, created_at: now, updated_at: now } ])
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "users_count counter cache" do
    let(:brand) { create(:brand) }

    it "increments the brand's users_count when created" do
      expect { create(:brand_user, brand: brand) }
        .to change { brand.reload.users_count }.from(0).to(1)
    end

    it "decrements the brand's users_count when destroyed" do
      brand_user = create(:brand_user, brand: brand)
      expect { brand_user.destroy }
        .to change { brand.reload.users_count }.from(1).to(0)
    end

    it "destroys its setting when destroyed" do
      brand_user = create(:brand_user, brand: brand)
      create(:setting, settable: brand_user)
      expect { brand_user.destroy }.to change(Setting, :count).by(-1)
    end
  end
end
