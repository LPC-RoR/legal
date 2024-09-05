require "application_system_test_case"

class KrnTipoMedidasTest < ApplicationSystemTestCase
  setup do
    @krn_tipo_medida = krn_tipo_medidas(:one)
  end

  test "visiting the index" do
    visit krn_tipo_medidas_url
    assert_selector "h1", text: "Krn tipo medidas"
  end

  test "should create krn tipo medida" do
    visit krn_tipo_medidas_url
    click_on "New krn tipo medida"

    fill_in "Cliente", with: @krn_tipo_medida.cliente_id
    check "Denunciado" if @krn_tipo_medida.denunciado
    check "Denunciante" if @krn_tipo_medida.denunciante
    fill_in "Empresa", with: @krn_tipo_medida.empresa_id
    fill_in "Krn tipo medida", with: @krn_tipo_medida.krn_tipo_medida
    fill_in "Tipo", with: @krn_tipo_medida.tipo
    click_on "Create Krn tipo medida"

    assert_text "Krn tipo medida was successfully created"
    click_on "Back"
  end

  test "should update Krn tipo medida" do
    visit krn_tipo_medida_url(@krn_tipo_medida)
    click_on "Edit this krn tipo medida", match: :first

    fill_in "Cliente", with: @krn_tipo_medida.cliente_id
    check "Denunciado" if @krn_tipo_medida.denunciado
    check "Denunciante" if @krn_tipo_medida.denunciante
    fill_in "Empresa", with: @krn_tipo_medida.empresa_id
    fill_in "Krn tipo medida", with: @krn_tipo_medida.krn_tipo_medida
    fill_in "Tipo", with: @krn_tipo_medida.tipo
    click_on "Update Krn tipo medida"

    assert_text "Krn tipo medida was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn tipo medida" do
    visit krn_tipo_medida_url(@krn_tipo_medida)
    click_on "Destroy this krn tipo medida", match: :first

    assert_text "Krn tipo medida was successfully destroyed"
  end
end
