require "application_system_test_case"

class KrnModificacionesTest < ApplicationSystemTestCase
  setup do
    @krn_modificacion = krn_modificaciones(:one)
  end

  test "visiting the index" do
    visit krn_modificaciones_url
    assert_selector "h1", text: "Krn modificaciones"
  end

  test "should create krn modificacion" do
    visit krn_modificaciones_url
    click_on "New krn modificacion"

    fill_in "Detalle", with: @krn_modificacion.detalle
    fill_in "Krn lst modificacion", with: @krn_modificacion.krn_lst_modificacion_id
    fill_in "Krn medida", with: @krn_modificacion.krn_medida_id
    click_on "Create Krn modificacion"

    assert_text "Krn modificacion was successfully created"
    click_on "Back"
  end

  test "should update Krn modificacion" do
    visit krn_modificacion_url(@krn_modificacion)
    click_on "Edit this krn modificacion", match: :first

    fill_in "Detalle", with: @krn_modificacion.detalle
    fill_in "Krn lst modificacion", with: @krn_modificacion.krn_lst_modificacion_id
    fill_in "Krn medida", with: @krn_modificacion.krn_medida_id
    click_on "Update Krn modificacion"

    assert_text "Krn modificacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn modificacion" do
    visit krn_modificacion_url(@krn_modificacion)
    click_on "Destroy this krn modificacion", match: :first

    assert_text "Krn modificacion was successfully destroyed"
  end
end
