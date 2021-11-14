require "application_system_test_case"

class StPerfilEstadosTest < ApplicationSystemTestCase
  setup do
    @st_perfil_estado = st_perfil_estados(:one)
  end

  test "visiting the index" do
    visit st_perfil_estados_url
    assert_selector "h1", text: "St Perfil Estados"
  end

  test "creating a St perfil estado" do
    visit st_perfil_estados_url
    click_on "New St Perfil Estado"

    fill_in "Rol", with: @st_perfil_estado.rol
    fill_in "St perfil estado", with: @st_perfil_estado.st_perfil_estado
    fill_in "St perfil modelo", with: @st_perfil_estado.st_perfil_modelo_id
    click_on "Create St perfil estado"

    assert_text "St perfil estado was successfully created"
    click_on "Back"
  end

  test "updating a St perfil estado" do
    visit st_perfil_estados_url
    click_on "Edit", match: :first

    fill_in "Rol", with: @st_perfil_estado.rol
    fill_in "St perfil estado", with: @st_perfil_estado.st_perfil_estado
    fill_in "St perfil modelo", with: @st_perfil_estado.st_perfil_modelo_id
    click_on "Update St perfil estado"

    assert_text "St perfil estado was successfully updated"
    click_on "Back"
  end

  test "destroying a St perfil estado" do
    visit st_perfil_estados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "St perfil estado was successfully destroyed"
  end
end
