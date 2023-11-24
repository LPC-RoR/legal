require "application_system_test_case"

class OrgRegionesTest < ApplicationSystemTestCase
  setup do
    @org_region = org_regiones(:one)
  end

  test "visiting the index" do
    visit org_regiones_url
    assert_selector "h1", text: "Org Regiones"
  end

  test "creating a Org region" do
    visit org_regiones_url
    click_on "New Org Region"

    fill_in "Orden", with: @org_region.orden
    fill_in "Org region", with: @org_region.org_region
    click_on "Create Org region"

    assert_text "Org region was successfully created"
    click_on "Back"
  end

  test "updating a Org region" do
    visit org_regiones_url
    click_on "Edit", match: :first

    fill_in "Orden", with: @org_region.orden
    fill_in "Org region", with: @org_region.org_region
    click_on "Update Org region"

    assert_text "Org region was successfully updated"
    click_on "Back"
  end

  test "destroying a Org region" do
    visit org_regiones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org region was successfully destroyed"
  end
end
