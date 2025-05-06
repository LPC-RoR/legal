require "application_system_test_case"

class PdfArchivosTest < ApplicationSystemTestCase
  setup do
    @pdf_archivo = pdf_archivos(:one)
  end

  test "visiting the index" do
    visit pdf_archivos_url
    assert_selector "h1", text: "Pdf archivos"
  end

  test "should create pdf archivo" do
    visit pdf_archivos_url
    click_on "New pdf archivo"

    fill_in "Codigo", with: @pdf_archivo.codigo
    fill_in "Modelos", with: @pdf_archivo.modelos
    fill_in "Nombre", with: @pdf_archivo.nombre
    fill_in "Ownr", with: @pdf_archivo.ownr_id
    fill_in "Ownr type", with: @pdf_archivo.ownr_type
    click_on "Create Pdf archivo"

    assert_text "Pdf archivo was successfully created"
    click_on "Back"
  end

  test "should update Pdf archivo" do
    visit pdf_archivo_url(@pdf_archivo)
    click_on "Edit this pdf archivo", match: :first

    fill_in "Codigo", with: @pdf_archivo.codigo
    fill_in "Modelos", with: @pdf_archivo.modelos
    fill_in "Nombre", with: @pdf_archivo.nombre
    fill_in "Ownr", with: @pdf_archivo.ownr_id
    fill_in "Ownr type", with: @pdf_archivo.ownr_type
    click_on "Update Pdf archivo"

    assert_text "Pdf archivo was successfully updated"
    click_on "Back"
  end

  test "should destroy Pdf archivo" do
    visit pdf_archivo_url(@pdf_archivo)
    click_on "Destroy this pdf archivo", match: :first

    assert_text "Pdf archivo was successfully destroyed"
  end
end
