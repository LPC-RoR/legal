require "application_system_test_case"

class KrnTramitesTest < ApplicationSystemTestCase
  setup do
    @krn_tramite = krn_tramites(:one)
  end

  test "visiting the index" do
    visit krn_tramites_url
    assert_selector "h1", text: "Krn tramites"
  end

  test "should create krn tramite" do
    visit krn_tramites_url
    click_on "New krn tramite"

    fill_in "Fecha hora", with: @krn_tramite.fecha_hora
    fill_in "Krn denuncia", with: @krn_tramite.krn_denuncia_id
    fill_in "Numero solicitutud", with: @krn_tramite.numero_solicitutud
    fill_in "Tipo", with: @krn_tramite.tipo
    click_on "Create Krn tramite"

    assert_text "Krn tramite was successfully created"
    click_on "Back"
  end

  test "should update Krn tramite" do
    visit krn_tramite_url(@krn_tramite)
    click_on "Edit this krn tramite", match: :first

    fill_in "Fecha hora", with: @krn_tramite.fecha_hora.to_s
    fill_in "Krn denuncia", with: @krn_tramite.krn_denuncia_id
    fill_in "Numero solicitutud", with: @krn_tramite.numero_solicitutud
    fill_in "Tipo", with: @krn_tramite.tipo
    click_on "Update Krn tramite"

    assert_text "Krn tramite was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn tramite" do
    visit krn_tramite_url(@krn_tramite)
    click_on "Destroy this krn tramite", match: :first

    assert_text "Krn tramite was successfully destroyed"
  end
end
