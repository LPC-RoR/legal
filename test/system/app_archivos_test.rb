require "application_system_test_case"

class AppArchivosTest < ApplicationSystemTestCase
  setup do
    @app_archivo = app_archivos(:one)
  end

  test "visiting the index" do
    visit app_archivos_url
    assert_selector "h1", text: "App Archivos"
  end

  test "creating a App archivo" do
    visit app_archivos_url
    click_on "New App Archivo"

    fill_in "Archivo", with: @app_archivo.archivo
    fill_in "Owner class", with: @app_archivo.owner_class
    fill_in "Owner", with: @app_archivo.owner_id
    click_on "Create App archivo"

    assert_text "App archivo was successfully created"
    click_on "Back"
  end

  test "updating a App archivo" do
    visit app_archivos_url
    click_on "Edit", match: :first

    fill_in "Archivo", with: @app_archivo.archivo
    fill_in "Owner class", with: @app_archivo.owner_class
    fill_in "Owner", with: @app_archivo.owner_id
    click_on "Update App archivo"

    assert_text "App archivo was successfully updated"
    click_on "Back"
  end

  test "destroying a App archivo" do
    visit app_archivos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App archivo was successfully destroyed"
  end
end
