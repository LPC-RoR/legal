require "application_system_test_case"

class AppNominasTest < ApplicationSystemTestCase
  setup do
    @app_nomina = app_nominas(:one)
  end

  test "visiting the index" do
    visit app_nominas_url
    assert_selector "h1", text: "App Nominas"
  end

  test "creating a App nomina" do
    visit app_nominas_url
    click_on "New App Nomina"

    fill_in "Email", with: @app_nomina.email
    fill_in "Nombre", with: @app_nomina.nombre
    fill_in "Tipo", with: @app_nomina.tipo
    click_on "Create App nomina"

    assert_text "App nomina was successfully created"
    click_on "Back"
  end

  test "updating a App nomina" do
    visit app_nominas_url
    click_on "Edit", match: :first

    fill_in "Email", with: @app_nomina.email
    fill_in "Nombre", with: @app_nomina.nombre
    fill_in "Tipo", with: @app_nomina.tipo
    click_on "Update App nomina"

    assert_text "App nomina was successfully updated"
    click_on "Back"
  end

  test "destroying a App nomina" do
    visit app_nominas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App nomina was successfully destroyed"
  end
end
