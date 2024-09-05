require "application_system_test_case"

class RepArchivosTest < ApplicationSystemTestCase
  setup do
    @rep_archivo = rep_archivos(:one)
  end

  test "visiting the index" do
    visit rep_archivos_url
    assert_selector "h1", text: "Rep archivos"
  end

  test "should create rep archivo" do
    visit rep_archivos_url
    click_on "New rep archivo"

    fill_in "Archivo", with: @rep_archivo.archivo
    fill_in "Ownr", with: @rep_archivo.ownr_id
    fill_in "Ownr type", with: @rep_archivo.ownr_type
    fill_in "Rep archivo", with: @rep_archivo.rep_archivo
    fill_in "Rep doc controlado", with: @rep_archivo.rep_doc_controlado_id
    click_on "Create Rep archivo"

    assert_text "Rep archivo was successfully created"
    click_on "Back"
  end

  test "should update Rep archivo" do
    visit rep_archivo_url(@rep_archivo)
    click_on "Edit this rep archivo", match: :first

    fill_in "Archivo", with: @rep_archivo.archivo
    fill_in "Ownr", with: @rep_archivo.ownr_id
    fill_in "Ownr type", with: @rep_archivo.ownr_type
    fill_in "Rep archivo", with: @rep_archivo.rep_archivo
    fill_in "Rep doc controlado", with: @rep_archivo.rep_doc_controlado_id
    click_on "Update Rep archivo"

    assert_text "Rep archivo was successfully updated"
    click_on "Back"
  end

  test "should destroy Rep archivo" do
    visit rep_archivo_url(@rep_archivo)
    click_on "Destroy this rep archivo", match: :first

    assert_text "Rep archivo was successfully destroyed"
  end
end
