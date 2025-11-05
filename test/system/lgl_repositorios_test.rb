require "application_system_test_case"

class LglRepositoriosTest < ApplicationSystemTestCase
  setup do
    @lgl_repositorio = lgl_repositorios(:one)
  end

  test "visiting the index" do
    visit lgl_repositorios_url
    assert_selector "h1", text: "Lgl repositorios"
  end

  test "should create lgl repositorio" do
    visit lgl_repositorios_url
    click_on "New lgl repositorio"

    fill_in "Dcg", with: @lgl_repositorio.dcg
    fill_in "Nombre", with: @lgl_repositorio.nombre
    click_on "Create Lgl repositorio"

    assert_text "Lgl repositorio was successfully created"
    click_on "Back"
  end

  test "should update Lgl repositorio" do
    visit lgl_repositorio_url(@lgl_repositorio)
    click_on "Edit this lgl repositorio", match: :first

    fill_in "Dcg", with: @lgl_repositorio.dcg
    fill_in "Nombre", with: @lgl_repositorio.nombre
    click_on "Update Lgl repositorio"

    assert_text "Lgl repositorio was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl repositorio" do
    visit lgl_repositorio_url(@lgl_repositorio)
    click_on "Destroy this lgl repositorio", match: :first

    assert_text "Lgl repositorio was successfully destroyed"
  end
end
