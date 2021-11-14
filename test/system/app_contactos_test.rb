require "application_system_test_case"

class AppContactosTest < ApplicationSystemTestCase
  setup do
    @app_contacto = app_contactos(:one)
  end

  test "visiting the index" do
    visit app_contactos_url
    assert_selector "h1", text: "App Contactos"
  end

  test "creating a App contacto" do
    visit app_contactos_url
    click_on "New App Contacto"

    fill_in "Email", with: @app_contacto.email
    fill_in "Nombre", with: @app_contacto.nombre
    fill_in "Owner class", with: @app_contacto.owner_class
    fill_in "Owner", with: @app_contacto.owner_id
    fill_in "Telefono", with: @app_contacto.telefono
    click_on "Create App contacto"

    assert_text "App contacto was successfully created"
    click_on "Back"
  end

  test "updating a App contacto" do
    visit app_contactos_url
    click_on "Edit", match: :first

    fill_in "Email", with: @app_contacto.email
    fill_in "Nombre", with: @app_contacto.nombre
    fill_in "Owner class", with: @app_contacto.owner_class
    fill_in "Owner", with: @app_contacto.owner_id
    fill_in "Telefono", with: @app_contacto.telefono
    click_on "Update App contacto"

    assert_text "App contacto was successfully updated"
    click_on "Back"
  end

  test "destroying a App contacto" do
    visit app_contactos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App contacto was successfully destroyed"
  end
end
