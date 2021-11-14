require "application_system_test_case"

class AppImagenesTest < ApplicationSystemTestCase
  setup do
    @app_imagen = app_imagenes(:one)
  end

  test "visiting the index" do
    visit app_imagenes_url
    assert_selector "h1", text: "App Imagenes"
  end

  test "creating a App imagen" do
    visit app_imagenes_url
    click_on "New App Imagen"

    fill_in "Credito imagen", with: @app_imagen.credito_imagen
    fill_in "Imagen", with: @app_imagen.imagen
    fill_in "Nombre", with: @app_imagen.nombre
    fill_in "Owner class", with: @app_imagen.owner_class
    fill_in "Owner", with: @app_imagen.owner_id
    click_on "Create App imagen"

    assert_text "App imagen was successfully created"
    click_on "Back"
  end

  test "updating a App imagen" do
    visit app_imagenes_url
    click_on "Edit", match: :first

    fill_in "Credito imagen", with: @app_imagen.credito_imagen
    fill_in "Imagen", with: @app_imagen.imagen
    fill_in "Nombre", with: @app_imagen.nombre
    fill_in "Owner class", with: @app_imagen.owner_class
    fill_in "Owner", with: @app_imagen.owner_id
    click_on "Update App imagen"

    assert_text "App imagen was successfully updated"
    click_on "Back"
  end

  test "destroying a App imagen" do
    visit app_imagenes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App imagen was successfully destroyed"
  end
end
