require "application_system_test_case"

class KrnDenunciantesTest < ApplicationSystemTestCase
  setup do
    @krn_denunciante = krn_denunciantes(:one)
  end

  test "visiting the index" do
    visit krn_denunciantes_url
    assert_selector "h1", text: "Krn denunciantes"
  end

  test "should create krn denunciante" do
    visit krn_denunciantes_url
    click_on "New krn denunciante"

    check "Articulo 4 1" if @krn_denunciante.articulo_4_1
    fill_in "Cargo", with: @krn_denunciante.cargo
    fill_in "Denuncia", with: @krn_denunciante.denuncia_id
    fill_in "Email", with: @krn_denunciante.email
    fill_in "Email ok", with: @krn_denunciante.email_ok
    fill_in "Empresa externa", with: @krn_denunciante.empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_denunciante.lugar_trabajo
    fill_in "Nombre", with: @krn_denunciante.nombre
    fill_in "Rut", with: @krn_denunciante.rut
    click_on "Create Krn denunciante"

    assert_text "Krn denunciante was successfully created"
    click_on "Back"
  end

  test "should update Krn denunciante" do
    visit krn_denunciante_url(@krn_denunciante)
    click_on "Edit this krn denunciante", match: :first

    check "Articulo 4 1" if @krn_denunciante.articulo_4_1
    fill_in "Cargo", with: @krn_denunciante.cargo
    fill_in "Denuncia", with: @krn_denunciante.denuncia_id
    fill_in "Email", with: @krn_denunciante.email
    fill_in "Email ok", with: @krn_denunciante.email_ok
    fill_in "Empresa externa", with: @krn_denunciante.empresa_externa_id
    fill_in "Lugar trabajo", with: @krn_denunciante.lugar_trabajo
    fill_in "Nombre", with: @krn_denunciante.nombre
    fill_in "Rut", with: @krn_denunciante.rut
    click_on "Update Krn denunciante"

    assert_text "Krn denunciante was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn denunciante" do
    visit krn_denunciante_url(@krn_denunciante)
    click_on "Destroy this krn denunciante", match: :first

    assert_text "Krn denunciante was successfully destroyed"
  end
end
