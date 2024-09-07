require "application_system_test_case"

class KrnDerivacionesTest < ApplicationSystemTestCase
  setup do
    @krn_derivacion = krn_derivaciones(:one)
  end

  test "visiting the index" do
    visit krn_derivaciones_url
    assert_selector "h1", text: "Krn derivaciones"
  end

  test "should create krn derivacion" do
    visit krn_derivaciones_url
    click_on "New krn derivacion"

    fill_in "Fecha", with: @krn_derivacion.fecha
    fill_in "Krn denuncia", with: @krn_derivacion.krn_denuncia_id
    fill_in "Krn empresa externa", with: @krn_derivacion.krn_empresa_externa_id
    fill_in "Krn motivo denuncia", with: @krn_derivacion.krn_motivo_denuncia_id
    fill_in "Otro motivo", with: @krn_derivacion.otro_motivo
    click_on "Create Krn derivacion"

    assert_text "Krn derivacion was successfully created"
    click_on "Back"
  end

  test "should update Krn derivacion" do
    visit krn_derivacion_url(@krn_derivacion)
    click_on "Edit this krn derivacion", match: :first

    fill_in "Fecha", with: @krn_derivacion.fecha
    fill_in "Krn denuncia", with: @krn_derivacion.krn_denuncia_id
    fill_in "Krn empresa externa", with: @krn_derivacion.krn_empresa_externa_id
    fill_in "Krn motivo denuncia", with: @krn_derivacion.krn_motivo_denuncia_id
    fill_in "Otro motivo", with: @krn_derivacion.otro_motivo
    click_on "Update Krn derivacion"

    assert_text "Krn derivacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn derivacion" do
    visit krn_derivacion_url(@krn_derivacion)
    click_on "Destroy this krn derivacion", match: :first

    assert_text "Krn derivacion was successfully destroyed"
  end
end
