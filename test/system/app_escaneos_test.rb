require "application_system_test_case"

class AppEscaneosTest < ApplicationSystemTestCase
  setup do
    @app_escaneo = app_escaneos(:one)
  end

  test "visiting the index" do
    visit app_escaneos_url
    assert_selector "h1", text: "App Escaneos"
  end

  test "creating a App escaneo" do
    visit app_escaneos_url
    click_on "New App Escaneo"

    fill_in "Ownr class", with: @app_escaneo.ownr_class
    fill_in "Ownr", with: @app_escaneo.ownr_id
    click_on "Create App escaneo"

    assert_text "App escaneo was successfully created"
    click_on "Back"
  end

  test "updating a App escaneo" do
    visit app_escaneos_url
    click_on "Edit", match: :first

    fill_in "Ownr class", with: @app_escaneo.ownr_class
    fill_in "Ownr", with: @app_escaneo.ownr_id
    click_on "Update App escaneo"

    assert_text "App escaneo was successfully updated"
    click_on "Back"
  end

  test "destroying a App escaneo" do
    visit app_escaneos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App escaneo was successfully destroyed"
  end
end
