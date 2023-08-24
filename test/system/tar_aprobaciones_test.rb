require "application_system_test_case"

class TarAprobacionesTest < ApplicationSystemTestCase
  setup do
    @tar_aprobacion = tar_aprobaciones(:one)
  end

  test "visiting the index" do
    visit tar_aprobaciones_url
    assert_selector "h1", text: "Tar Aprobaciones"
  end

  test "creating a Tar aprobacion" do
    visit tar_aprobaciones_url
    click_on "New Tar Aprobacion"

    fill_in "Cliente", with: @tar_aprobacion.cliente_id
    fill_in "Fecha", with: @tar_aprobacion.fecha
    click_on "Create Tar aprobacion"

    assert_text "Tar aprobacion was successfully created"
    click_on "Back"
  end

  test "updating a Tar aprobacion" do
    visit tar_aprobaciones_url
    click_on "Edit", match: :first

    fill_in "Cliente", with: @tar_aprobacion.cliente_id
    fill_in "Fecha", with: @tar_aprobacion.fecha
    click_on "Update Tar aprobacion"

    assert_text "Tar aprobacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar aprobacion" do
    visit tar_aprobaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar aprobacion was successfully destroyed"
  end
end
