require "application_system_test_case"

class KrnDenunciasTest < ApplicationSystemTestCase
  setup do
    @krn_denuncia = krn_denuncias(:one)
  end

  test "visiting the index" do
    visit krn_denuncias_url
    assert_selector "h1", text: "Krn denuncias"
  end

  test "should create krn denuncia" do
    visit krn_denuncias_url
    click_on "New krn denuncia"

    fill_in "Cliente", with: @krn_denuncia.cliente_id
    fill_in "Empresa receptora", with: @krn_denuncia.empresa_receptora_id
    fill_in "Fecha hora", with: @krn_denuncia.fecha_hora
    fill_in "Fecha hora dt", with: @krn_denuncia.fecha_hora_dt
    fill_in "Fecha hora recepcion", with: @krn_denuncia.fecha_hora_recepcion
    fill_in "Investigador", with: @krn_denuncia.investigador_id
    fill_in "Motivo denuncia", with: @krn_denuncia.motivo_denuncia_id
    fill_in "Receptor denuncia", with: @krn_denuncia.receptor_denuncia_id
    click_on "Create Krn denuncia"

    assert_text "Krn denuncia was successfully created"
    click_on "Back"
  end

  test "should update Krn denuncia" do
    visit krn_denuncia_url(@krn_denuncia)
    click_on "Edit this krn denuncia", match: :first

    fill_in "Cliente", with: @krn_denuncia.cliente_id
    fill_in "Empresa receptora", with: @krn_denuncia.empresa_receptora_id
    fill_in "Fecha hora", with: @krn_denuncia.fecha_hora
    fill_in "Fecha hora dt", with: @krn_denuncia.fecha_hora_dt
    fill_in "Fecha hora recepcion", with: @krn_denuncia.fecha_hora_recepcion
    fill_in "Investigador", with: @krn_denuncia.investigador_id
    fill_in "Motivo denuncia", with: @krn_denuncia.motivo_denuncia_id
    fill_in "Receptor denuncia", with: @krn_denuncia.receptor_denuncia_id
    click_on "Update Krn denuncia"

    assert_text "Krn denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn denuncia" do
    visit krn_denuncia_url(@krn_denuncia)
    click_on "Destroy this krn denuncia", match: :first

    assert_text "Krn denuncia was successfully destroyed"
  end
end
