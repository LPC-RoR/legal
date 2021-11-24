require "application_system_test_case"

class TarConveniosTest < ApplicationSystemTestCase
  setup do
    @tar_convenio = tar_convenios(:one)
  end

  test "visiting the index" do
    visit tar_convenios_url
    assert_selector "h1", text: "Tar Convenios"
  end

  test "creating a Tar convenio" do
    visit tar_convenios_url
    click_on "New Tar Convenio"

    fill_in "Estado", with: @tar_convenio.estado
    fill_in "Fecha", with: @tar_convenio.fecha
    fill_in "Monto", with: @tar_convenio.monto
    fill_in "Tar factura", with: @tar_convenio.tar_factura_id
    click_on "Create Tar convenio"

    assert_text "Tar convenio was successfully created"
    click_on "Back"
  end

  test "updating a Tar convenio" do
    visit tar_convenios_url
    click_on "Edit", match: :first

    fill_in "Estado", with: @tar_convenio.estado
    fill_in "Fecha", with: @tar_convenio.fecha
    fill_in "Monto", with: @tar_convenio.monto
    fill_in "Tar factura", with: @tar_convenio.tar_factura_id
    click_on "Update Tar convenio"

    assert_text "Tar convenio was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar convenio" do
    visit tar_convenios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar convenio was successfully destroyed"
  end
end
