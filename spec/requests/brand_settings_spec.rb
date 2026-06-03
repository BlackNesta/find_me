# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Brand settings", type: :request do
  let!(:brand) { create(:brand) }

  describe "POST /brand_settings" do
    it "adds a brand-level setting" do
      expect {
        post brand_settings_path, params: { brand_id: brand.id, setting: { key: "theme", value: "dark" } }, as: :turbo_stream
      }.to change { brand.settings.count }.by(1)

      expect(response).to have_http_status(:ok)
      expect(brand.settings.last.key).to eq("theme")
    end

    it "rejects a blank key or value" do
      expect {
        post brand_settings_path, params: { brand_id: brand.id, setting: { key: "", value: "" } }, as: :turbo_stream
      }.not_to change { brand.settings.count }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "rejects a duplicate key for the same brand" do
      create(:setting, settable: brand, key: "theme")

      expect {
        post brand_settings_path, params: { brand_id: brand.id, setting: { key: "theme", value: "x" } }, as: :turbo_stream
      }.not_to change { brand.settings.count }

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /brand_settings/:id" do
    it "removes a brand-level setting" do
      setting = create(:setting, settable: brand, key: "theme")

      expect {
        delete brand_setting_path(setting, brand_id: brand.id), as: :turbo_stream
      }.to change { brand.settings.count }.by(-1)
    end
  end
end
