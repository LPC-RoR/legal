require "application_system_test_case"

class ComDocumentosTest < ApplicationSystemTestCase
  setup do
    @com_documento = com_documentos(:one)
  end

  test "visiting the index" do
    visit com_documentos_url
    assert_selector "h1", text: "Com documentos"
  end

  test "should create com documento" do
    visit com_documentos_url
    click_on "New com documento"

    fill_in "Doc type", with: @com_documento.doc_type
    fill_in "Issued on", with: @com_documento.issued_on
    fill_in "Titulo", with: @com_documento.titulo
    click_on "Create Com documento"

    assert_text "Com documento was successfully created"
    click_on "Back"
  end

  test "should update Com documento" do
    visit com_documento_url(@com_documento)
    click_on "Edit this com documento", match: :first

    fill_in "Doc type", with: @com_documento.doc_type
    fill_in "Issued on", with: @com_documento.issued_on
    fill_in "Titulo", with: @com_documento.titulo
    click_on "Update Com documento"

    assert_text "Com documento was successfully updated"
    click_on "Back"
  end

  test "should destroy Com documento" do
    visit com_documento_url(@com_documento)
    click_on "Destroy this com documento", match: :first

    assert_text "Com documento was successfully destroyed"
  end
end
