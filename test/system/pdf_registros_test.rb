require "application_system_test_case"

class PdfRegistrosTest < ApplicationSystemTestCase
  setup do
    @pdf_registro = pdf_registros(:one)
  end

  test "visiting the index" do
    visit pdf_registros_url
    assert_selector "h1", text: "Pdf registros"
  end

  test "should create pdf registro" do
    visit pdf_registros_url
    click_on "New pdf registro"

    fill_in "Ownr", with: @pdf_registro.ownr_id
    fill_in "Ownr type", with: @pdf_registro.ownr_type
    fill_in "Pdf archivo", with: @pdf_registro.pdf_archivo_id
    click_on "Create Pdf registro"

    assert_text "Pdf registro was successfully created"
    click_on "Back"
  end

  test "should update Pdf registro" do
    visit pdf_registro_url(@pdf_registro)
    click_on "Edit this pdf registro", match: :first

    fill_in "Ownr", with: @pdf_registro.ownr_id
    fill_in "Ownr type", with: @pdf_registro.ownr_type
    fill_in "Pdf archivo", with: @pdf_registro.pdf_archivo_id
    click_on "Update Pdf registro"

    assert_text "Pdf registro was successfully updated"
    click_on "Back"
  end

  test "should destroy Pdf registro" do
    visit pdf_registro_url(@pdf_registro)
    click_on "Destroy this pdf registro", match: :first

    assert_text "Pdf registro was successfully destroyed"
  end
end
