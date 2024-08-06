require "application_system_test_case"

class DenunciasTest < ApplicationSystemTestCase
  setup do
    @denuncia = denuncias(:one)
  end

  test "visiting the index" do
    visit denuncias_url
    assert_selector "h1", text: "Denuncias"
  end

  test "should create denuncia" do
    visit denuncias_url
    click_on "New denuncia"

    fill_in "Cargo", with: @denuncia.cargo
    fill_in "Denunciante", with: @denuncia.denunciante
    fill_in "Email", with: @denuncia.email
    check "Empleador dt tercero" if @denuncia.empleador_dt_tercero
    fill_in "Empresa", with: @denuncia.empresa_id
    fill_in "Lugar trabajo", with: @denuncia.lugar_trabajo
    check "Presencial electronica" if @denuncia.presencial_electronica
    fill_in "Rut", with: @denuncia.rut
    fill_in "Tipo denuncia", with: @denuncia.tipo_denuncia_id
    check "Verbal escrita" if @denuncia.verbal_escrita
    click_on "Create Denuncia"

    assert_text "Denuncia was successfully created"
    click_on "Back"
  end

  test "should update Denuncia" do
    visit denuncia_url(@denuncia)
    click_on "Edit this denuncia", match: :first

    fill_in "Cargo", with: @denuncia.cargo
    fill_in "Denunciante", with: @denuncia.denunciante
    fill_in "Email", with: @denuncia.email
    check "Empleador dt tercero" if @denuncia.empleador_dt_tercero
    fill_in "Empresa", with: @denuncia.empresa_id
    fill_in "Lugar trabajo", with: @denuncia.lugar_trabajo
    check "Presencial electronica" if @denuncia.presencial_electronica
    fill_in "Rut", with: @denuncia.rut
    fill_in "Tipo denuncia", with: @denuncia.tipo_denuncia_id
    check "Verbal escrita" if @denuncia.verbal_escrita
    click_on "Update Denuncia"

    assert_text "Denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Denuncia" do
    visit denuncia_url(@denuncia)
    click_on "Destroy this denuncia", match: :first

    assert_text "Denuncia was successfully destroyed"
  end
end
