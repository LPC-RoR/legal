require "application_system_test_case"

class RcrsLogosTest < ApplicationSystemTestCase
  setup do
    @rcrs_logo = rcrs_logos(:one)
  end

  test "visiting the index" do
    visit rcrs_logos_url
    assert_selector "h1", text: "Rcrs logos"
  end

  test "should create rcrs logo" do
    visit rcrs_logos_url
    click_on "New rcrs logo"

    fill_in "Logo", with: @rcrs_logo.logo
    fill_in "Ownr", with: @rcrs_logo.ownr_id
    fill_in "Ownr type", with: @rcrs_logo.ownr_type
    click_on "Create Rcrs logo"

    assert_text "Rcrs logo was successfully created"
    click_on "Back"
  end

  test "should update Rcrs logo" do
    visit rcrs_logo_url(@rcrs_logo)
    click_on "Edit this rcrs logo", match: :first

    fill_in "Logo", with: @rcrs_logo.logo
    fill_in "Ownr", with: @rcrs_logo.ownr_id
    fill_in "Ownr type", with: @rcrs_logo.ownr_type
    click_on "Update Rcrs logo"

    assert_text "Rcrs logo was successfully updated"
    click_on "Back"
  end

  test "should destroy Rcrs logo" do
    visit rcrs_logo_url(@rcrs_logo)
    click_on "Destroy this rcrs logo", match: :first

    assert_text "Rcrs logo was successfully destroyed"
  end
end
