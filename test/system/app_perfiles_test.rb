require "application_system_test_case"

class AppPerfilesTest < ApplicationSystemTestCase
  setup do
    @app_perfil = app_perfiles(:one)
  end

  test "visiting the index" do
    visit app_perfiles_url
    assert_selector "h1", text: "App Perfiles"
  end

  test "creating a App perfil" do
    visit app_perfiles_url
    click_on "New App Perfil"

    fill_in "App administrador", with: @app_perfil.app_administrador_id
    fill_in "Email", with: @app_perfil.email
    fill_in "Usuario", with: @app_perfil.usuario_id
    click_on "Create App perfil"

    assert_text "App perfil was successfully created"
    click_on "Back"
  end

  test "updating a App perfil" do
    visit app_perfiles_url
    click_on "Edit", match: :first

    fill_in "App administrador", with: @app_perfil.app_administrador_id
    fill_in "Email", with: @app_perfil.email
    fill_in "Usuario", with: @app_perfil.usuario_id
    click_on "Update App perfil"

    assert_text "App perfil was successfully updated"
    click_on "Back"
  end

  test "destroying a App perfil" do
    visit app_perfiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App perfil was successfully destroyed"
  end
end
