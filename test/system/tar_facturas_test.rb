require "application_system_test_case"

class TarFacturasTest < ApplicationSystemTestCase
  setup do
    @tar_factura = tar_facturas(:one)
  end

  test "visiting the index" do
    visit tar_facturas_url
    assert_selector "h1", text: "Tar Facturas"
  end

  test "creating a Tar factura" do
    visit tar_facturas_url
    click_on "New Tar Factura"

    fill_in "Documento", with: @tar_factura.documento
    fill_in "Estado", with: @tar_factura.estado
    fill_in "Owner class", with: @tar_factura.owner_class
    fill_in "Owner", with: @tar_factura.owner_id
    click_on "Create Tar factura"

    assert_text "Tar factura was successfully created"
    click_on "Back"
  end

  test "updating a Tar factura" do
    visit tar_facturas_url
    click_on "Edit", match: :first

    fill_in "Documento", with: @tar_factura.documento
    fill_in "Estado", with: @tar_factura.estado
    fill_in "Owner class", with: @tar_factura.owner_class
    fill_in "Owner", with: @tar_factura.owner_id
    click_on "Update Tar factura"

    assert_text "Tar factura was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar factura" do
    visit tar_facturas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar factura was successfully destroyed"
  end
end
