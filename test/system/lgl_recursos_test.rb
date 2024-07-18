require "application_system_test_case"

class LglRecursosTest < ApplicationSystemTestCase
  setup do
    @lgl_recurso = lgl_recursos(:one)
  end

  test "visiting the index" do
    visit lgl_recursos_url
    assert_selector "h1", text: "Lgl recursos"
  end

  test "should create lgl recurso" do
    visit lgl_recursos_url
    click_on "New lgl recurso"

    fill_in "Lgl recurso", with: @lgl_recurso.lgl_recurso
    fill_in "Tipo", with: @lgl_recurso.tipo
    click_on "Create Lgl recurso"

    assert_text "Lgl recurso was successfully created"
    click_on "Back"
  end

  test "should update Lgl recurso" do
    visit lgl_recurso_url(@lgl_recurso)
    click_on "Edit this lgl recurso", match: :first

    fill_in "Lgl recurso", with: @lgl_recurso.lgl_recurso
    fill_in "Tipo", with: @lgl_recurso.tipo
    click_on "Update Lgl recurso"

    assert_text "Lgl recurso was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl recurso" do
    visit lgl_recurso_url(@lgl_recurso)
    click_on "Destroy this lgl recurso", match: :first

    assert_text "Lgl recurso was successfully destroyed"
  end
end
