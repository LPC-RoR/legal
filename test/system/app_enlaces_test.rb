require "application_system_test_case"

class AppEnlacesTest < ApplicationSystemTestCase
  setup do
    @app_enlace = app_enlaces(:one)
  end

  test "visiting the index" do
    visit app_enlaces_url
    assert_selector "h1", text: "App Enlaces"
  end

  test "creating a App enlace" do
    visit app_enlaces_url
    click_on "New App Enlace"

    fill_in "Descripcion", with: @app_enlace.descripcion
    fill_in "Enlace", with: @app_enlace.enlace
    fill_in "Owner class", with: @app_enlace.owner_class
    fill_in "Owner", with: @app_enlace.owner_id
    click_on "Create App enlace"

    assert_text "App enlace was successfully created"
    click_on "Back"
  end

  test "updating a App enlace" do
    visit app_enlaces_url
    click_on "Edit", match: :first

    fill_in "Descripcion", with: @app_enlace.descripcion
    fill_in "Enlace", with: @app_enlace.enlace
    fill_in "Owner class", with: @app_enlace.owner_class
    fill_in "Owner", with: @app_enlace.owner_id
    click_on "Update App enlace"

    assert_text "App enlace was successfully updated"
    click_on "Back"
  end

  test "destroying a App enlace" do
    visit app_enlaces_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App enlace was successfully destroyed"
  end
end
