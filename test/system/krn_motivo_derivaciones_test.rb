require "application_system_test_case"

class KrnMotivoDerivacionesTest < ApplicationSystemTestCase
  setup do
    @krn_motivo_derivacion = krn_motivo_derivaciones(:one)
  end

  test "visiting the index" do
    visit krn_motivo_derivaciones_url
    assert_selector "h1", text: "Krn motivo derivaciones"
  end

  test "should create krn motivo derivacion" do
    visit krn_motivo_derivaciones_url
    click_on "New krn motivo derivacion"

    fill_in "Krn motivo derivacion", with: @krn_motivo_derivacion.krn_motivo_derivacion
    click_on "Create Krn motivo derivacion"

    assert_text "Krn motivo derivacion was successfully created"
    click_on "Back"
  end

  test "should update Krn motivo derivacion" do
    visit krn_motivo_derivacion_url(@krn_motivo_derivacion)
    click_on "Edit this krn motivo derivacion", match: :first

    fill_in "Krn motivo derivacion", with: @krn_motivo_derivacion.krn_motivo_derivacion
    click_on "Update Krn motivo derivacion"

    assert_text "Krn motivo derivacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn motivo derivacion" do
    visit krn_motivo_derivacion_url(@krn_motivo_derivacion)
    click_on "Destroy this krn motivo derivacion", match: :first

    assert_text "Krn motivo derivacion was successfully destroyed"
  end
end
