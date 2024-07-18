require "application_system_test_case"

class LglEntidadesTest < ApplicationSystemTestCase
  setup do
    @lgl_entidad = lgl_entidades(:one)
  end

  test "visiting the index" do
    visit lgl_entidades_url
    assert_selector "h1", text: "Lgl entidades"
  end

  test "should create lgl entidad" do
    visit lgl_entidades_url
    click_on "New lgl entidad"

    fill_in "Dependencia", with: @lgl_entidad.dependencia
    fill_in "Lgl entidad", with: @lgl_entidad.lgl_entidad
    fill_in "Tipo", with: @lgl_entidad.tipo
    click_on "Create Lgl entidad"

    assert_text "Lgl entidad was successfully created"
    click_on "Back"
  end

  test "should update Lgl entidad" do
    visit lgl_entidad_url(@lgl_entidad)
    click_on "Edit this lgl entidad", match: :first

    fill_in "Dependencia", with: @lgl_entidad.dependencia
    fill_in "Lgl entidad", with: @lgl_entidad.lgl_entidad
    fill_in "Tipo", with: @lgl_entidad.tipo
    click_on "Update Lgl entidad"

    assert_text "Lgl entidad was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl entidad" do
    visit lgl_entidad_url(@lgl_entidad)
    click_on "Destroy this lgl entidad", match: :first

    assert_text "Lgl entidad was successfully destroyed"
  end
end
