require "application_system_test_case"

class AppControlDocumentosTest < ApplicationSystemTestCase
  setup do
    @app_control_documento = app_control_documentos(:one)
  end

  test "visiting the index" do
    visit app_control_documentos_url
    assert_selector "h1", text: "App Control Documentos"
  end

  test "creating a App control documento" do
    visit app_control_documentos_url
    click_on "New App Control Documento"

    fill_in "App control documento", with: @app_control_documento.app_control_documento
    fill_in "Existencia", with: @app_control_documento.existencia
    fill_in "Owner", with: @app_control_documento.owner_id
    fill_in "Ownr class", with: @app_control_documento.ownr_class
    fill_in "Vencimiento", with: @app_control_documento.vencimiento
    click_on "Create App control documento"

    assert_text "App control documento was successfully created"
    click_on "Back"
  end

  test "updating a App control documento" do
    visit app_control_documentos_url
    click_on "Edit", match: :first

    fill_in "App control documento", with: @app_control_documento.app_control_documento
    fill_in "Existencia", with: @app_control_documento.existencia
    fill_in "Owner", with: @app_control_documento.owner_id
    fill_in "Ownr class", with: @app_control_documento.ownr_class
    fill_in "Vencimiento", with: @app_control_documento.vencimiento
    click_on "Update App control documento"

    assert_text "App control documento was successfully updated"
    click_on "Back"
  end

  test "destroying a App control documento" do
    visit app_control_documentos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App control documento was successfully destroyed"
  end
end
