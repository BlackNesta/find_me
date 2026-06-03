# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:brand) { create(:brand) }

  describe "GET /" do
    it "renders the brand's users with their setting and the add-user form" do
      user = create(:user, email: "jane@example.com")
      brand_user = create(:brand_user, brand: brand, user: user)
      create(:setting, settable: brand_user, key: "theme", value: "dark")

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("jane@example.com")
      expect(response.body).to include("theme")
      expect(response.body).to include("dark")
      expect(response.body).to include("Choose a user")
      expect(response.body).to include("New user")
    end
  end

  describe "POST /users" do
    it "creates a new user, membership, and setting; increments users_count" do
      expect {
        post users_path, params: {
          brand_id: brand.id,
          user: { first_name: "John", last_name: "Doe", email: "john@example.com" },
          setting: { key: "theme", value: "dark" }
        }, as: :turbo_stream
      }.to change { brand.reload.users_count }.from(0).to(1)
        .and change(BrandUser, :count).by(1)
        .and change(Setting, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(brand.users.pluck(:email)).to eq(["john@example.com"])
    end

    it "links an existing user chosen from the dropdown" do
      existing = create(:user, email: "jane@example.com")

      expect {
        post users_path, params: { brand_id: brand.id, existing_user_id: existing.id }, as: :turbo_stream
      }.to change { brand.reload.users_count }.by(1).and change(User, :count).by(0)

      expect(brand.users).to include(existing)
    end

    it "does not reuse an existing user by email when creating a new one" do
      create(:user, email: "jane@example.com")

      expect {
        post users_path, params: { brand_id: brand.id, user: { first_name: "X", last_name: "Y", email: "jane@example.com" } }, as: :turbo_stream
      }.not_to change { brand.reload.users_count }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "does not create with invalid params" do
      expect {
        post users_path, params: { brand_id: brand.id, user: { first_name: "", last_name: "", email: "" } }, as: :turbo_stream
      }.not_to change { brand.reload.users_count }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "adds the user to the brand identified by brand_id" do
      other = create(:brand)

      post users_path, params: { brand_id: other.id, user: { first_name: "John", last_name: "Doe", email: "john@example.com" } }, as: :turbo_stream

      expect(other.reload.users_count).to eq(1)
      expect(brand.reload.users_count).to eq(0)
    end
  end

  describe "DELETE /users/:id" do
    it "removes the membership and decrements users_count, keeping the user" do
      user = create(:user, email: "jane@example.com")
      create(:brand_user, brand: brand, user: user)

      expect {
        delete user_path(user, brand_id: brand.id), as: :turbo_stream
      }.to change { brand.reload.users_count }.from(1).to(0).and change(BrandUser, :count).by(-1)

      expect(User.exists?(user.id)).to be(true)
      expect(brand.users).not_to include(user)
    end

    it "does not affect the user's membership in other brands" do
      other = create(:brand)
      user = create(:user, email: "jane@example.com")
      create(:brand_user, brand: brand, user: user)
      create(:brand_user, brand: other, user: user)

      delete user_path(user, brand_id: brand.id), as: :turbo_stream

      expect(brand.reload.users).not_to include(user)
      expect(other.reload.users).to include(user)
    end
  end
end
