# frozen_string_literal: true

require "rails_helper"

RSpec.describe UpdateBrand do
  it "updates and normalizes the brand name" do
    brand = create(:brand, name: "original")

    UpdateBrand.result(brand: brand, attributes: { name: " Test ACME Brand " })

    expect(brand.reload.name).to eq("acmebrand")
  end

  it "leaves the brand unchanged when the name is invalid" do
    brand = create(:brand, name: "original")

    UpdateBrand.result(brand: brand, attributes: { name: "test" })

    expect(brand.errors[:name]).to include("can't be blank")
    expect(brand.reload.name).to eq("original")
  end
end
