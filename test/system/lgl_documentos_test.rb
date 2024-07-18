require "application_system_test_case"

class LglDocumentosTest < ApplicationSystemTestCase
  setup do
    @lgl_documento = lgl_documentos(:one)
  end

  test "visiting the index" do
    visit lgl_documentos_url
    assert_selector "h1", text: "Lgl documentos"
  end

  test "should create lgl documento" do
    visit lgl_documentos_url
    click_on "New lgl documento"

    fill_in "Lgl documento", with: @lgl_documento.lgl_documento
    fill_in "Tipo", with: @lgl_documento.tipo
    click_on "Create Lgl documento"

    assert_text "Lgl documento was successfully created"
    click_on "Back"
  end

  test "should update Lgl documento" do
    visit lgl_documento_url(@lgl_documento)
    click_on "Edit this lgl documento", match: :first

    fill_in "Lgl documento", with: @lgl_documento.lgl_documento
    fill_in "Tipo", with: @lgl_documento.tipo
    click_on "Update Lgl documento"

    assert_text "Lgl documento was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl documento" do
    visit lgl_documento_url(@lgl_documento)
    click_on "Destroy this lgl documento", match: :first

    assert_text "Lgl documento was successfully destroyed"
  end
end
