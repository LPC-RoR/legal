require "application_system_test_case"

class OrgAreaAreasTest < ApplicationSystemTestCase
  setup do
    @org_area_area = org_area_areas(:one)
  end

  test "visiting the index" do
    visit org_area_areas_url
    assert_selector "h1", text: "Org Area Areas"
  end

  test "creating a Org area area" do
    visit org_area_areas_url
    click_on "New Org Area Area"

    fill_in "Child", with: @org_area_area.child_id
    fill_in "Parent", with: @org_area_area.parent_id
    click_on "Create Org area area"

    assert_text "Org area area was successfully created"
    click_on "Back"
  end

  test "updating a Org area area" do
    visit org_area_areas_url
    click_on "Edit", match: :first

    fill_in "Child", with: @org_area_area.child_id
    fill_in "Parent", with: @org_area_area.parent_id
    click_on "Update Org area area"

    assert_text "Org area area was successfully updated"
    click_on "Back"
  end

  test "destroying a Org area area" do
    visit org_area_areas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org area area was successfully destroyed"
  end
end
