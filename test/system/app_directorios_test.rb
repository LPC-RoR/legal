require "application_system_test_case"

class AppDirectoriosTest < ApplicationSystemTestCase
  setup do
    @app_directorio = app_directorios(:one)
  end

  test "visiting the index" do
    visit app_directorios_url
    assert_selector "h1", text: "App Directorios"
  end

  test "creating a App directorio" do
    visit app_directorios_url
    click_on "New App Directorio"

    fill_in "App repo", with: @app_directorio.app_repo_id
    fill_in "Directorio", with: @app_directorio.directorio
    click_on "Create App directorio"

    assert_text "App directorio was successfully created"
    click_on "Back"
  end

  test "updating a App directorio" do
    visit app_directorios_url
    click_on "Edit", match: :first

    fill_in "App repo", with: @app_directorio.app_repo_id
    fill_in "Directorio", with: @app_directorio.directorio
    click_on "Update App directorio"

    assert_text "App directorio was successfully updated"
    click_on "Back"
  end

  test "destroying a App directorio" do
    visit app_directorios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App directorio was successfully destroyed"
  end
end
