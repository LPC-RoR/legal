require "application_system_test_case"

class RcrsEnlacesTest < ApplicationSystemTestCase
  setup do
    @rcrs_enlace = rcrs_enlaces(:one)
  end

  test "visiting the index" do
    visit rcrs_enlaces_url
    assert_selector "h1", text: "Rcrs enlaces"
  end

  test "should create rcrs enlace" do
    visit rcrs_enlaces_url
    click_on "New rcrs enlace"

    fill_in "Descripcion", with: @rcrs_enlace.descripcion
    fill_in "Link", with: @rcrs_enlace.link
    fill_in "Ownr", with: @rcrs_enlace.ownr_id
    fill_in "Ownr type", with: @rcrs_enlace.ownr_type
    click_on "Create Rcrs enlace"

    assert_text "Rcrs enlace was successfully created"
    click_on "Back"
  end

  test "should update Rcrs enlace" do
    visit rcrs_enlace_url(@rcrs_enlace)
    click_on "Edit this rcrs enlace", match: :first

    fill_in "Descripcion", with: @rcrs_enlace.descripcion
    fill_in "Link", with: @rcrs_enlace.link
    fill_in "Ownr", with: @rcrs_enlace.ownr_id
    fill_in "Ownr type", with: @rcrs_enlace.ownr_type
    click_on "Update Rcrs enlace"

    assert_text "Rcrs enlace was successfully updated"
    click_on "Back"
  end

  test "should destroy Rcrs enlace" do
    visit rcrs_enlace_url(@rcrs_enlace)
    click_on "Destroy this rcrs enlace", match: :first

    assert_text "Rcrs enlace was successfully destroyed"
  end
end
