# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Brands", type: :request do
  let!(:brand) { create(:brand, name: "oldname") }

  describe "PATCH /brand" do
    it "autosaves the normalized brand name and refreshes the switcher text" do
      patch brand_path, params: { brand: { name: " New Brand " } }, as: :turbo_stream

      expect(response).to have_http_status(:ok)
      expect(brand.reload.name).to eq("newbrand")
      expect(response.body).to include("Saved")
      # also streams an update to this brand's switcher entry with the new name
      expect(response.body).to include("switch_brand_#{brand.id}")
      expect(response.body).to include("newbrand")
    end

    it "does not update with an invalid name and reports the error" do
      patch brand_path, params: { brand: { name: "test" } }, as: :turbo_stream

      expect(response).to have_http_status(:unprocessable_content)
      expect(brand.reload.name).to eq("oldname")
      expect(response.body).to include("can&#39;t be blank").or include("can't be blank")
    end
  end

  describe "POST /brands" do
    it "creates a brand and redirects to it" do
      expect {
        post brands_path, params: { brand: { name: "  New Co " } }
      }.to change(Brand, :count).by(1)

      created = Brand.find_by(name: "newco")
      expect(created).to be_present
      expect(response).to redirect_to(root_path(brand_id: created.id))
    end

    it "does not create an invalid brand" do
      expect {
        post brands_path, params: { brand: { name: "test" } }
      }.not_to change(Brand, :count)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include("can't be blank")
    end
  end
end
