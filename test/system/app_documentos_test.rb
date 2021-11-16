require "application_system_test_case"

class AppDocumentosTest < ApplicationSystemTestCase
  setup do
    @app_documento = app_documentos(:one)
  end

  test "visiting the index" do
    visit app_documentos_url
    assert_selector "h1", text: "App Documentos"
  end

  test "creating a App documento" do
    visit app_documentos_url
    click_on "New App Documento"

    fill_in "App directorio", with: @app_documento.app_directorio_id
    fill_in "Documento", with: @app_documento.documento
    check "Publico" if @app_documento.publico
    click_on "Create App documento"

    assert_text "App documento was successfully created"
    click_on "Back"
  end

  test "updating a App documento" do
    visit app_documentos_url
    click_on "Edit", match: :first

    fill_in "App directorio", with: @app_documento.app_directorio_id
    fill_in "Documento", with: @app_documento.documento
    check "Publico" if @app_documento.publico
    click_on "Update App documento"

    assert_text "App documento was successfully updated"
    click_on "Back"
  end

  test "destroying a App documento" do
    visit app_documentos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App documento was successfully destroyed"
  end
end
