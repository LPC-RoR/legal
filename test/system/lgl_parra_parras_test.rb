require "application_system_test_case"

class LglParraParrasTest < ApplicationSystemTestCase
  setup do
    @lgl_parra_parra = lgl_parra_parras(:one)
  end

  test "visiting the index" do
    visit lgl_parra_parras_url
    assert_selector "h1", text: "Lgl parra parras"
  end

  test "should create lgl parra parra" do
    visit lgl_parra_parras_url
    click_on "New lgl parra parra"

    fill_in "Child", with: @lgl_parra_parra.child_id
    fill_in "Parent", with: @lgl_parra_parra.parent_id
    click_on "Create Lgl parra parra"

    assert_text "Lgl parra parra was successfully created"
    click_on "Back"
  end

  test "should update Lgl parra parra" do
    visit lgl_parra_parra_url(@lgl_parra_parra)
    click_on "Edit this lgl parra parra", match: :first

    fill_in "Child", with: @lgl_parra_parra.child_id
    fill_in "Parent", with: @lgl_parra_parra.parent_id
    click_on "Update Lgl parra parra"

    assert_text "Lgl parra parra was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl parra parra" do
    visit lgl_parra_parra_url(@lgl_parra_parra)
    click_on "Destroy this lgl parra parra", match: :first

    assert_text "Lgl parra parra was successfully destroyed"
  end
end
