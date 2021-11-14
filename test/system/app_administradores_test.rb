require "application_system_test_case"

class AppAdministradoresTest < ApplicationSystemTestCase
  setup do
    @app_administrador = app_administradores(:one)
  end

  test "visiting the index" do
    visit app_administradores_url
    assert_selector "h1", text: "App Administradores"
  end

  test "creating a App administrador" do
    visit app_administradores_url
    click_on "New App Administrador"

    fill_in "Administrador", with: @app_administrador.administrador
    fill_in "Email", with: @app_administrador.email
    fill_in "Usuario", with: @app_administrador.usuario_id
    click_on "Create App administrador"

    assert_text "App administrador was successfully created"
    click_on "Back"
  end

  test "updating a App administrador" do
    visit app_administradores_url
    click_on "Edit", match: :first

    fill_in "Administrador", with: @app_administrador.administrador
    fill_in "Email", with: @app_administrador.email
    fill_in "Usuario", with: @app_administrador.usuario_id
    click_on "Update App administrador"

    assert_text "App administrador was successfully updated"
    click_on "Back"
  end

  test "destroying a App administrador" do
    visit app_administradores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App administrador was successfully destroyed"
  end
end
