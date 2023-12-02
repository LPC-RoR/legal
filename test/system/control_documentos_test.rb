require "application_system_test_case"

class ControlDocumentosTest < ApplicationSystemTestCase
  setup do
    @control_documento = control_documentos(:one)
  end

  test "visiting the index" do
    visit control_documentos_url
    assert_selector "h1", text: "Control Documentos"
  end

  test "creating a Control documento" do
    visit control_documentos_url
    click_on "New Control Documento"

    fill_in "Control", with: @control_documento.control
    fill_in "Descripcion", with: @control_documento.descripcion
    fill_in "Nombre", with: @control_documento.nombre
    fill_in "Tipo", with: @control_documento.tipo
    click_on "Create Control documento"

    assert_text "Control documento was successfully created"
    click_on "Back"
  end

  test "updating a Control documento" do
    visit control_documentos_url
    click_on "Edit", match: :first

    fill_in "Control", with: @control_documento.control
    fill_in "Descripcion", with: @control_documento.descripcion
    fill_in "Nombre", with: @control_documento.nombre
    fill_in "Tipo", with: @control_documento.tipo
    click_on "Update Control documento"

    assert_text "Control documento was successfully updated"
    click_on "Back"
  end

  test "destroying a Control documento" do
    visit control_documentos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Control documento was successfully destroyed"
  end
end
