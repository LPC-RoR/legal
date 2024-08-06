require "application_system_test_case"

class DenunciadosTest < ApplicationSystemTestCase
  setup do
    @denunciado = denunciados(:one)
  end

  test "visiting the index" do
    visit denunciados_url
    assert_selector "h1", text: "Denunciados"
  end

  test "should create denunciado" do
    visit denunciados_url
    click_on "New denunciado"

    fill_in "Cargo", with: @denunciado.cargo
    fill_in "Denuncia", with: @denunciado.denuncia_id
    fill_in "Denunciado", with: @denunciado.denunciado
    fill_in "Email", with: @denunciado.email
    fill_in "Lugar trabajo", with: @denunciado.lugar_trabajo
    fill_in "Rut", with: @denunciado.rut
    fill_in "Tipo denunciado", with: @denunciado.tipo_denunciado_id
    fill_in "Vinculo", with: @denunciado.vinculo
    click_on "Create Denunciado"

    assert_text "Denunciado was successfully created"
    click_on "Back"
  end

  test "should update Denunciado" do
    visit denunciado_url(@denunciado)
    click_on "Edit this denunciado", match: :first

    fill_in "Cargo", with: @denunciado.cargo
    fill_in "Denuncia", with: @denunciado.denuncia_id
    fill_in "Denunciado", with: @denunciado.denunciado
    fill_in "Email", with: @denunciado.email
    fill_in "Lugar trabajo", with: @denunciado.lugar_trabajo
    fill_in "Rut", with: @denunciado.rut
    fill_in "Tipo denunciado", with: @denunciado.tipo_denunciado_id
    fill_in "Vinculo", with: @denunciado.vinculo
    click_on "Update Denunciado"

    assert_text "Denunciado was successfully updated"
    click_on "Back"
  end

  test "should destroy Denunciado" do
    visit denunciado_url(@denunciado)
    click_on "Destroy this denunciado", match: :first

    assert_text "Denunciado was successfully destroyed"
  end
end
