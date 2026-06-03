# frozen_string_literal: true

require "rails_helper"

RSpec.describe AddUserToBrand do
  let(:brand) { create(:brand) }

  def add(user_id: nil, user_params: {}, setting_params: {})
    AddUserToBrand.result(brand: brand, user_id: user_id, user_params: user_params, setting_params: setting_params).brand_user
  end

  it "creates a new user, a membership, and its setting" do
    brand_user = nil
    expect {
      brand_user = add(user_params: { first_name: "John", last_name: "Doe", email: "john@example.com" },
                       setting_params: { key: "theme", value: "dark" })
    }.to change(User, :count).by(1)
      .and change(BrandUser, :count).by(1)
      .and change(Setting, :count).by(1)
      .and change { brand.reload.users_count }.by(1)

    expect(brand_user).to be_persisted
    expect(brand_user.setting.key).to eq("theme")
  end

  it "normalizes the new user's attributes" do
    brand_user = add(user_params: { first_name: " Test John ", last_name: "Do e", email: "John@Example.com" })
    expect([brand_user.user.first_name, brand_user.user.last_name, brand_user.user.email]).to eq(["john", "doe", "john@example.com"])
  end

  it "links an existing user selected by id without creating a new one" do
    existing = create(:user, email: "jane@example.com")
    expect {
      add(user_id: existing.id, setting_params: { key: "lang" })
    }.to change(User, :count).by(0).and change(BrandUser, :count).by(1)

    expect(brand.users).to include(existing)
  end

  it "does NOT silently reuse an existing user by email for a new user" do
    create(:user, email: "jane@example.com")
    brand_user = nil
    expect {
      brand_user = add(user_params: { first_name: "X", last_name: "Y", email: "jane@example.com" })
    }.to change(BrandUser, :count).by(0)

    expect(brand_user.errors.full_messages).to include("Email has already been taken")
  end

  it "rejects linking the same existing user twice" do
    existing = create(:user)
    add(user_id: existing.id)

    brand_user = nil
    expect { brand_user = add(user_id: existing.id) }.not_to change { brand.reload.users_count }
    expect(brand_user.errors.full_messages).to include("User is already added to this brand")
  end

  it "creates nothing for an invalid new user and reports errors" do
    brand_user = nil
    expect {
      brand_user = add(user_params: { first_name: "test", last_name: "", email: "" })
    }.to change(User, :count).by(0).and change(BrandUser, :count).by(0)

    expect(brand_user).not_to be_persisted
    expect(brand_user.errors.full_messages).to include("First name can't be blank")
  end
end
