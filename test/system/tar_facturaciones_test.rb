require "application_system_test_case"

class TarFacturacionesTest < ApplicationSystemTestCase
  setup do
    @tar_facturacion = tar_facturaciones(:one)
  end

  test "visiting the index" do
    visit tar_facturaciones_url
    assert_selector "h1", text: "Tar Facturaciones"
  end

  test "creating a Tar facturacion" do
    visit tar_facturaciones_url
    click_on "New Tar Facturacion"

    fill_in "Estado", with: @tar_facturacion.estado
    fill_in "Facturable", with: @tar_facturacion.facturable
    fill_in "Monto", with: @tar_facturacion.monto
    fill_in "Owner class", with: @tar_facturacion.owner_class
    fill_in "Owner", with: @tar_facturacion.owner_id
    click_on "Create Tar facturacion"

    assert_text "Tar facturacion was successfully created"
    click_on "Back"
  end

  test "updating a Tar facturacion" do
    visit tar_facturaciones_url
    click_on "Edit", match: :first

    fill_in "Estado", with: @tar_facturacion.estado
    fill_in "Facturable", with: @tar_facturacion.facturable
    fill_in "Monto", with: @tar_facturacion.monto
    fill_in "Owner class", with: @tar_facturacion.owner_class
    fill_in "Owner", with: @tar_facturacion.owner_id
    click_on "Update Tar facturacion"

    assert_text "Tar facturacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar facturacion" do
    visit tar_facturaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar facturacion was successfully destroyed"
  end
end
