require "application_system_test_case"

class StPerfilModelosTest < ApplicationSystemTestCase
  setup do
    @st_perfil_modelo = st_perfil_modelos(:one)
  end

  test "visiting the index" do
    visit st_perfil_modelos_url
    assert_selector "h1", text: "St Perfil Modelos"
  end

  test "creating a St perfil modelo" do
    visit st_perfil_modelos_url
    click_on "New St Perfil Modelo"

    fill_in "App nomina", with: @st_perfil_modelo.app_nomina_id
    check "Ingresa registros" if @st_perfil_modelo.ingresa_registros
    fill_in "Rol", with: @st_perfil_modelo.rol
    fill_in "St perfil modelo", with: @st_perfil_modelo.st_perfil_modelo
    click_on "Create St perfil modelo"

    assert_text "St perfil modelo was successfully created"
    click_on "Back"
  end

  test "updating a St perfil modelo" do
    visit st_perfil_modelos_url
    click_on "Edit", match: :first

    fill_in "App nomina", with: @st_perfil_modelo.app_nomina_id
    check "Ingresa registros" if @st_perfil_modelo.ingresa_registros
    fill_in "Rol", with: @st_perfil_modelo.rol
    fill_in "St perfil modelo", with: @st_perfil_modelo.st_perfil_modelo
    click_on "Update St perfil modelo"

    assert_text "St perfil modelo was successfully updated"
    click_on "Back"
  end

  test "destroying a St perfil modelo" do
    visit st_perfil_modelos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "St perfil modelo was successfully destroyed"
  end
end
