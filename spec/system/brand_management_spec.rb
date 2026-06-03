# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Brand management", type: :system do
  let!(:brand) { create(:brand, name: "oldname") }

  it "autosaves the normalized brand name" do
    visit root_path

    fill_in "Brand name", with: "New Brand"
    find("h2.card-title", text: "Users").click # blur the field -> triggers save

    expect(page).to have_content("Saved")
    expect(brand.reload.name).to eq("newbrand")
  end

  it "updates the switcher label live when the brand name is saved" do
    create(:brand, name: "other") # second brand -> switcher is shown

    visit root_path(brand_id: brand.id)
    within("#brand_switcher") { expect(page).to have_link("oldname") }

    fill_in "Brand name", with: "Renamed"
    find("h2.card-title", text: "Users").click # blur -> save

    expect(page).to have_content("Saved")
    within("#brand_switcher") { expect(page).to have_link("renamed") }
  end

  it "creates a new brand from the form" do
    visit root_path

    fill_in "New brand", with: "Fresh Co"
    click_button "Create brand"

    expect(page).to have_content("Brand created")
    expect(Brand.find_by(name: "freshco")).to be_present
  end

  it "adds a new user (with a setting) and updates the count live, then removes them" do
    visit root_path
    expect(find("#users_count")).to have_text("0")

    fill_in "First name", with: "John"
    fill_in "Last name", with: "Doe"
    fill_in "Email", with: "john@example.com"
    fill_in "Setting key", with: "theme"
    fill_in "Setting value", with: "dark"
    click_button "Add user"

    expect(page).to have_content("john doe (john@example.com)")
    expect(page).to have_content("theme: dark")
    expect(find("#users_count")).to have_text("1")
    expect(brand.reload.users_count).to eq(1)

    accept_confirm { click_button "Remove" }

    within("#users") { expect(page).not_to have_content("john@example.com") }
    expect(find("#users_count")).to have_text("0")
    # the removed user is selectable again in the dropdown
    expect(page).to have_select("existing_user_id", with_options: [ "john@example.com" ])
  end

  it "adds an existing user via the dropdown" do
    user = create(:user, first_name: "jane", last_name: "doe", email: "jane@example.com")

    visit root_path
    select "jane@example.com", from: "existing_user_id"
    click_button "Add user"

    expect(page).to have_content("jane doe (jane@example.com)")
    expect(brand.reload.users).to include(user)
  end
end
