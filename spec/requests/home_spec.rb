# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "shows no switcher when only one brand exists" do
      create(:brand, name: "solo")

      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("brand_switcher")
    end

    it "scopes to the selected brand and renders a switcher when several exist" do
      first = create(:brand, name: "first")
      second = create(:brand, name: "second")
      create(:brand_user, brand: first, user: create(:user, email: "f@example.com"))
      create(:brand_user, brand: second, user: create(:user, email: "s@example.com"))

      get root_path(brand_id: second.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('value="second"')
      expect(response.body).to include("s@example.com")
      expect(response.body).to include(root_path(brand_id: first.id))
      expect(response.body).to include(root_path(brand_id: second.id))
    end
  end
end
