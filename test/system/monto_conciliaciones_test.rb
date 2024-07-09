require "application_system_test_case"

class MontoConciliacionesTest < ApplicationSystemTestCase
  setup do
    @monto_conciliacion = monto_conciliaciones(:one)
  end

  test "visiting the index" do
    visit monto_conciliaciones_url
    assert_selector "h1", text: "Monto conciliaciones"
  end

  test "should create monto conciliacion" do
    visit monto_conciliaciones_url
    click_on "New monto conciliacion"

    fill_in "Causa", with: @monto_conciliacion.causa_id
    fill_in "Fecha", with: @monto_conciliacion.fecha
    fill_in "Monto", with: @monto_conciliacion.monto
    fill_in "Tipo", with: @monto_conciliacion.tipo
    click_on "Create Monto conciliacion"

    assert_text "Monto conciliacion was successfully created"
    click_on "Back"
  end

  test "should update Monto conciliacion" do
    visit monto_conciliacion_url(@monto_conciliacion)
    click_on "Edit this monto conciliacion", match: :first

    fill_in "Causa", with: @monto_conciliacion.causa_id
    fill_in "Fecha", with: @monto_conciliacion.fecha
    fill_in "Monto", with: @monto_conciliacion.monto
    fill_in "Tipo", with: @monto_conciliacion.tipo
    click_on "Update Monto conciliacion"

    assert_text "Monto conciliacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Monto conciliacion" do
    visit monto_conciliacion_url(@monto_conciliacion)
    click_on "Destroy this monto conciliacion", match: :first

    assert_text "Monto conciliacion was successfully destroyed"
  end
end
