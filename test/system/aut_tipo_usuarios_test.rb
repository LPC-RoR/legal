require "application_system_test_case"

class AutTipoUsuariosTest < ApplicationSystemTestCase
  setup do
    @aut_tipo_usuario = aut_tipo_usuarios(:one)
  end

  test "visiting the index" do
    visit aut_tipo_usuarios_url
    assert_selector "h1", text: "Aut Tipo Usuarios"
  end

  test "creating a Aut tipo usuario" do
    visit aut_tipo_usuarios_url
    click_on "New Aut Tipo Usuario"

    fill_in "Aut tipo usuario", with: @aut_tipo_usuario.aut_tipo_usuario
    click_on "Create Aut tipo usuario"

    assert_text "Aut tipo usuario was successfully created"
    click_on "Back"
  end

  test "updating a Aut tipo usuario" do
    visit aut_tipo_usuarios_url
    click_on "Edit", match: :first

    fill_in "Aut tipo usuario", with: @aut_tipo_usuario.aut_tipo_usuario
    click_on "Update Aut tipo usuario"

    assert_text "Aut tipo usuario was successfully updated"
    click_on "Back"
  end

  test "destroying a Aut tipo usuario" do
    visit aut_tipo_usuarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Aut tipo usuario was successfully destroyed"
  end
end
