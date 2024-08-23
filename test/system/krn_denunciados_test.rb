require "application_system_test_case"

class KrnDenunciadosTest < ApplicationSystemTestCase
  setup do
    @krn_denunciado = krn_denunciados(:one)
  end

  test "visiting the index" do
    visit krn_denunciados_url
    assert_selector "h1", text: "Krn denunciados"
  end

  test "should create krn denunciado" do
    visit krn_denunciados_url
    click_on "New krn denunciado"

    check "Articulo 4 1" if @krn_denunciado.articulo_4_1
    fill_in "Cargo", with: @krn_denunciado.cargo
    fill_in "Denuncia", with: @krn_denunciado.denuncia_id
    fill_in "Email", with: @krn_denunciado.email
    fill_in "Email ok", with: @krn_denunciado.email_ok
    fill_in "Empresa externa", with: @krn_denunciado.empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_denunciado.lugar_trabajo
    fill_in "Nombre", with: @krn_denunciado.nombre
    fill_in "Rut", with: @krn_denunciado.rut
    click_on "Create Krn denunciado"

    assert_text "Krn denunciado was successfully created"
    click_on "Back"
  end

  test "should update Krn denunciado" do
    visit krn_denunciado_url(@krn_denunciado)
    click_on "Edit this krn denunciado", match: :first

    check "Articulo 4 1" if @krn_denunciado.articulo_4_1
    fill_in "Cargo", with: @krn_denunciado.cargo
    fill_in "Denuncia", with: @krn_denunciado.denuncia_id
    fill_in "Email", with: @krn_denunciado.email
    fill_in "Email ok", with: @krn_denunciado.email_ok
    fill_in "Empresa externa", with: @krn_denunciado.empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_denunciado.lugar_trabajo
    fill_in "Nombre", with: @krn_denunciado.nombre
    fill_in "Rut", with: @krn_denunciado.rut
    click_on "Update Krn denunciado"

    assert_text "Krn denunciado was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn denunciado" do
    visit krn_denunciado_url(@krn_denunciado)
    click_on "Destroy this krn denunciado", match: :first

    assert_text "Krn denunciado was successfully destroyed"
  end
end
