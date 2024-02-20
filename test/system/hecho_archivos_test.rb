require "application_system_test_case"

class HechoArchivosTest < ApplicationSystemTestCase
  setup do
    @hecho_archivo = hecho_archivos(:one)
  end

  test "visiting the index" do
    visit hecho_archivos_url
    assert_selector "h1", text: "Hecho Archivos"
  end

  test "creating a Hecho archivo" do
    visit hecho_archivos_url
    click_on "New Hecho Archivo"

    fill_in "App archivo", with: @hecho_archivo.app_archivo_id
    check "Establece" if @hecho_archivo.establece
    fill_in "Hecho", with: @hecho_archivo.hecho_id
    fill_in "Orden", with: @hecho_archivo.orden
    click_on "Create Hecho archivo"

    assert_text "Hecho archivo was successfully created"
    click_on "Back"
  end

  test "updating a Hecho archivo" do
    visit hecho_archivos_url
    click_on "Edit", match: :first

    fill_in "App archivo", with: @hecho_archivo.app_archivo_id
    check "Establece" if @hecho_archivo.establece
    fill_in "Hecho", with: @hecho_archivo.hecho_id
    fill_in "Orden", with: @hecho_archivo.orden
    click_on "Update Hecho archivo"

    assert_text "Hecho archivo was successfully updated"
    click_on "Back"
  end

  test "destroying a Hecho archivo" do
    visit hecho_archivos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hecho archivo was successfully destroyed"
  end
end
