require "application_system_test_case"

class RegionesTest < ApplicationSystemTestCase
  setup do
    @region = regiones(:one)
  end

  test "visiting the index" do
    visit regiones_url
    assert_selector "h1", text: "Regiones"
  end

  test "creating a Region" do
    visit regiones_url
    click_on "New Region"

    fill_in "Orden", with: @region.orden
    fill_in "Region", with: @region.region
    click_on "Create Region"

    assert_text "Region was successfully created"
    click_on "Back"
  end

  test "updating a Region" do
    visit regiones_url
    click_on "Edit", match: :first

    fill_in "Orden", with: @region.orden
    fill_in "Region", with: @region.region
    click_on "Update Region"

    assert_text "Region was successfully updated"
    click_on "Back"
  end

  test "destroying a Region" do
    visit regiones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Region was successfully destroyed"
  end
end
