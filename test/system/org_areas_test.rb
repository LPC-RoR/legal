require "application_system_test_case"

class OrgAreasTest < ApplicationSystemTestCase
  setup do
    @org_area = org_areas(:one)
  end

  test "visiting the index" do
    visit org_areas_url
    assert_selector "h1", text: "Org Areas"
  end

  test "creating a Org area" do
    visit org_areas_url
    click_on "New Org Area"

    fill_in "Org area", with: @org_area.org_area
    click_on "Create Org area"

    assert_text "Org area was successfully created"
    click_on "Back"
  end

  test "updating a Org area" do
    visit org_areas_url
    click_on "Edit", match: :first

    fill_in "Org area", with: @org_area.org_area
    click_on "Update Org area"

    assert_text "Org area was successfully updated"
    click_on "Back"
  end

  test "destroying a Org area" do
    visit org_areas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org area was successfully destroyed"
  end
end
