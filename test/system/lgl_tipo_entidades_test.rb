require "application_system_test_case"

class LglTipoEntidadesTest < ApplicationSystemTestCase
  setup do
    @lgl_tipo_entidad = lgl_tipo_entidades(:one)
  end

  test "visiting the index" do
    visit lgl_tipo_entidades_url
    assert_selector "h1", text: "Lgl tipo entidades"
  end

  test "should create lgl tipo entidad" do
    visit lgl_tipo_entidades_url
    click_on "New lgl tipo entidad"

    fill_in "Lgl tipo entidad", with: @lgl_tipo_entidad.lgl_tipo_entidad
    click_on "Create Lgl tipo entidad"

    assert_text "Lgl tipo entidad was successfully created"
    click_on "Back"
  end

  test "should update Lgl tipo entidad" do
    visit lgl_tipo_entidad_url(@lgl_tipo_entidad)
    click_on "Edit this lgl tipo entidad", match: :first

    fill_in "Lgl tipo entidad", with: @lgl_tipo_entidad.lgl_tipo_entidad
    click_on "Update Lgl tipo entidad"

    assert_text "Lgl tipo entidad was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl tipo entidad" do
    visit lgl_tipo_entidad_url(@lgl_tipo_entidad)
    click_on "Destroy this lgl tipo entidad", match: :first

    assert_text "Lgl tipo entidad was successfully destroyed"
  end
end
