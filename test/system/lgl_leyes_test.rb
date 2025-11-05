require "application_system_test_case"

class LglLeyesTest < ApplicationSystemTestCase
  setup do
    @lgl_ley = lgl_leyes(:one)
  end

  test "visiting the index" do
    visit lgl_leyes_url
    assert_selector "h1", text: "Lgl leyes"
  end

  test "should create lgl ley" do
    visit lgl_leyes_url
    click_on "New lgl ley"

    fill_in "Cdg", with: @lgl_ley.cdg
    fill_in "Lgl repositorio", with: @lgl_ley.lgl_repositorio_id
    fill_in "Nombre", with: @lgl_ley.nombre
    click_on "Create Lgl ley"

    assert_text "Lgl ley was successfully created"
    click_on "Back"
  end

  test "should update Lgl ley" do
    visit lgl_ley_url(@lgl_ley)
    click_on "Edit this lgl ley", match: :first

    fill_in "Cdg", with: @lgl_ley.cdg
    fill_in "Lgl repositorio", with: @lgl_ley.lgl_repositorio_id
    fill_in "Nombre", with: @lgl_ley.nombre
    click_on "Update Lgl ley"

    assert_text "Lgl ley was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl ley" do
    visit lgl_ley_url(@lgl_ley)
    click_on "Destroy this lgl ley", match: :first

    assert_text "Lgl ley was successfully destroyed"
  end
end
