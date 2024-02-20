require "application_system_test_case"

class CausaArchivosTest < ApplicationSystemTestCase
  setup do
    @causa_archivo = causa_archivos(:one)
  end

  test "visiting the index" do
    visit causa_archivos_url
    assert_selector "h1", text: "Causa Archivos"
  end

  test "creating a Causa archivo" do
    visit causa_archivos_url
    click_on "New Causa Archivo"

    fill_in "App archivo", with: @causa_archivo.app_archivo_id
    fill_in "Causa", with: @causa_archivo.causa_id
    fill_in "Orden", with: @causa_archivo.orden
    check "Seleccionado" if @causa_archivo.seleccionado
    click_on "Create Causa archivo"

    assert_text "Causa archivo was successfully created"
    click_on "Back"
  end

  test "updating a Causa archivo" do
    visit causa_archivos_url
    click_on "Edit", match: :first

    fill_in "App archivo", with: @causa_archivo.app_archivo_id
    fill_in "Causa", with: @causa_archivo.causa_id
    fill_in "Orden", with: @causa_archivo.orden
    check "Seleccionado" if @causa_archivo.seleccionado
    click_on "Update Causa archivo"

    assert_text "Causa archivo was successfully updated"
    click_on "Back"
  end

  test "destroying a Causa archivo" do
    visit causa_archivos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Causa archivo was successfully destroyed"
  end
end
