require "application_system_test_case"

class AppRecursosTest < ApplicationSystemTestCase
  setup do
    @app_recurso = app_recursos(:one)
  end

  test "visiting the index" do
    visit app_recursos_url
    assert_selector "h1", text: "App Recursos"
  end

  test "creating a App recurso" do
    visit app_recursos_url
    click_on "New App Recurso"

    click_on "Create App recurso"

    assert_text "App recurso was successfully created"
    click_on "Back"
  end

  test "updating a App recurso" do
    visit app_recursos_url
    click_on "Edit", match: :first

    click_on "Update App recurso"

    assert_text "App recurso was successfully updated"
    click_on "Back"
  end

  test "destroying a App recurso" do
    visit app_recursos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App recurso was successfully destroyed"
  end
end
