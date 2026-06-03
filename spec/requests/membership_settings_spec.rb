# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Membership settings", type: :request do
  let!(:brand) { create(:brand) }
  let(:user) { create(:user, email: "jane@example.com") }
  let!(:brand_user) { create(:brand_user, brand: brand, user: user) }

  describe "PATCH /membership_settings/:id" do
    it "updates the member's existing setting" do
      create(:setting, settable: brand_user, key: "old", value: "v1")

      patch membership_setting_path(user, brand_id: brand.id),
            params: { setting: { key: "theme", value: "dark" } }, as: :turbo_stream

      expect(response).to have_http_status(:ok)
      expect(brand_user.reload.setting.slice(:key, :value).values).to eq(%w[theme dark])
    end

    it "creates the setting when the member doesn't have one yet" do
      expect(brand_user.setting).to be_nil

      patch membership_setting_path(user, brand_id: brand.id),
            params: { setting: { key: "theme", value: "dark" } }, as: :turbo_stream

      expect(response).to have_http_status(:ok)
      expect(brand_user.reload.setting&.key).to eq("theme")
    end

    it "only touches the membership in the current brand" do
      other = create(:brand)
      other_membership = create(:brand_user, brand: other, user: user)
      create(:setting, settable: other_membership, key: "keep", value: "me")

      patch membership_setting_path(user, brand_id: brand.id),
            params: { setting: { key: "theme", value: "dark" } }, as: :turbo_stream

      expect(other_membership.reload.setting.slice(:key, :value).values).to eq(%w[keep me])
    end
  end
end
