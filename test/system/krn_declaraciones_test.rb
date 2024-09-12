require "application_system_test_case"

class KrnDeclaracionesTest < ApplicationSystemTestCase
  setup do
    @krn_declaracion = krn_declaraciones(:one)
  end

  test "visiting the index" do
    visit krn_declaraciones_url
    assert_selector "h1", text: "Krn declaraciones"
  end

  test "should create krn declaracion" do
    visit krn_declaraciones_url
    click_on "New krn declaracion"

    fill_in "Archivo", with: @krn_declaracion.archivo
    fill_in "Fecha", with: @krn_declaracion.fecha
    fill_in "Krn denuncia", with: @krn_declaracion.krn_denuncia_id
    fill_in "Ownr", with: @krn_declaracion.ownr_id
    fill_in "Ownr type", with: @krn_declaracion.ownr_type
    click_on "Create Krn declaracion"

    assert_text "Krn declaracion was successfully created"
    click_on "Back"
  end

  test "should update Krn declaracion" do
    visit krn_declaracion_url(@krn_declaracion)
    click_on "Edit this krn declaracion", match: :first

    fill_in "Archivo", with: @krn_declaracion.archivo
    fill_in "Fecha", with: @krn_declaracion.fecha
    fill_in "Krn denuncia", with: @krn_declaracion.krn_denuncia_id
    fill_in "Ownr", with: @krn_declaracion.ownr_id
    fill_in "Ownr type", with: @krn_declaracion.ownr_type
    click_on "Update Krn declaracion"

    assert_text "Krn declaracion was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn declaracion" do
    visit krn_declaracion_url(@krn_declaracion)
    click_on "Destroy this krn declaracion", match: :first

    assert_text "Krn declaracion was successfully destroyed"
  end
end
