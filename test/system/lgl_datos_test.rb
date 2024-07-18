require "application_system_test_case"

class LglDatosTest < ApplicationSystemTestCase
  setup do
    @lgl_dato = lgl_datos(:one)
  end

  test "visiting the index" do
    visit lgl_datos_url
    assert_selector "h1", text: "Lgl datos"
  end

  test "should create lgl dato" do
    visit lgl_datos_url
    click_on "New lgl dato"

    fill_in "Cita", with: @lgl_dato.cita
    fill_in "Lgl dato", with: @lgl_dato.lgl_dato
    fill_in "Lgl parrafo", with: @lgl_dato.lgl_parrafo_id
    fill_in "Orden", with: @lgl_dato.orden
    click_on "Create Lgl dato"

    assert_text "Lgl dato was successfully created"
    click_on "Back"
  end

  test "should update Lgl dato" do
    visit lgl_dato_url(@lgl_dato)
    click_on "Edit this lgl dato", match: :first

    fill_in "Cita", with: @lgl_dato.cita
    fill_in "Lgl dato", with: @lgl_dato.lgl_dato
    fill_in "Lgl parrafo", with: @lgl_dato.lgl_parrafo_id
    fill_in "Orden", with: @lgl_dato.orden
    click_on "Update Lgl dato"

    assert_text "Lgl dato was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl dato" do
    visit lgl_dato_url(@lgl_dato)
    click_on "Destroy this lgl dato", match: :first

    assert_text "Lgl dato was successfully destroyed"
  end
end
