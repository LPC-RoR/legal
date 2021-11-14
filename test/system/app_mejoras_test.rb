require "application_system_test_case"

class AppMejorasTest < ApplicationSystemTestCase
  setup do
    @app_mejora = app_mejoras(:one)
  end

  test "visiting the index" do
    visit app_mejoras_url
    assert_selector "h1", text: "App Mejoras"
  end

  test "creating a App mejora" do
    visit app_mejoras_url
    click_on "New App Mejora"

    fill_in "App perfil", with: @app_mejora.app_perfil_id
    fill_in "Detalle", with: @app_mejora.detalle
    fill_in "Estado", with: @app_mejora.estado
    fill_in "Owner class", with: @app_mejora.owner_class
    fill_in "Owner", with: @app_mejora.owner_id
    click_on "Create App mejora"

    assert_text "App mejora was successfully created"
    click_on "Back"
  end

  test "updating a App mejora" do
    visit app_mejoras_url
    click_on "Edit", match: :first

    fill_in "App perfil", with: @app_mejora.app_perfil_id
    fill_in "Detalle", with: @app_mejora.detalle
    fill_in "Estado", with: @app_mejora.estado
    fill_in "Owner class", with: @app_mejora.owner_class
    fill_in "Owner", with: @app_mejora.owner_id
    click_on "Update App mejora"

    assert_text "App mejora was successfully updated"
    click_on "Back"
  end

  test "destroying a App mejora" do
    visit app_mejoras_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App mejora was successfully destroyed"
  end
end
