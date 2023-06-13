require "application_system_test_case"

class TarUfFacturacionesTest < ApplicationSystemTestCase
  setup do
    @tar_uf_facturacion = tar_uf_facturaciones(:one)
  end

  test "visiting the index" do
    visit tar_uf_facturaciones_url
    assert_selector "h1", text: "Tar Uf Facturaciones"
  end

  test "creating a Tar uf facturacion" do
    visit tar_uf_facturaciones_url
    click_on "New Tar Uf Facturacion"

    fill_in "Fecha uf", with: @tar_uf_facturacion.fecha_uf
    fill_in "Owner class", with: @tar_uf_facturacion.owner_class
    fill_in "Owner", with: @tar_uf_facturacion.owner_id
    fill_in "Pago", with: @tar_uf_facturacion.pago
    click_on "Create Tar uf facturacion"

    assert_text "Tar uf facturacion was successfully created"
    click_on "Back"
  end

  test "updating a Tar uf facturacion" do
    visit tar_uf_facturaciones_url
    click_on "Edit", match: :first

    fill_in "Fecha uf", with: @tar_uf_facturacion.fecha_uf
    fill_in "Owner class", with: @tar_uf_facturacion.owner_class
    fill_in "Owner", with: @tar_uf_facturacion.owner_id
    fill_in "Pago", with: @tar_uf_facturacion.pago
    click_on "Update Tar uf facturacion"

    assert_text "Tar uf facturacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar uf facturacion" do
    visit tar_uf_facturaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar uf facturacion was successfully destroyed"
  end
end
