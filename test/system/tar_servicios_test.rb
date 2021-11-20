require "application_system_test_case"

class TarServiciosTest < ApplicationSystemTestCase
  setup do
    @tar_servicio = tar_servicios(:one)
  end

  test "visiting the index" do
    visit tar_servicios_url
    assert_selector "h1", text: "Tar Servicios"
  end

  test "creating a Tar servicio" do
    visit tar_servicios_url
    click_on "New Tar Servicio"

    fill_in "Codigo", with: @tar_servicio.codigo
    fill_in "Descripcion", with: @tar_servicio.descripcion
    fill_in "Detalle", with: @tar_servicio.detalle
    fill_in "Moneda", with: @tar_servicio.moneda
    fill_in "Monto", with: @tar_servicio.monto
    fill_in "Objeto", with: @tar_servicio.objeto_id
    fill_in "Owner class", with: @tar_servicio.owner_class
    fill_in "Tipo", with: @tar_servicio.tipo
    click_on "Create Tar servicio"

    assert_text "Tar servicio was successfully created"
    click_on "Back"
  end

  test "updating a Tar servicio" do
    visit tar_servicios_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @tar_servicio.codigo
    fill_in "Descripcion", with: @tar_servicio.descripcion
    fill_in "Detalle", with: @tar_servicio.detalle
    fill_in "Moneda", with: @tar_servicio.moneda
    fill_in "Monto", with: @tar_servicio.monto
    fill_in "Objeto", with: @tar_servicio.objeto_id
    fill_in "Owner class", with: @tar_servicio.owner_class
    fill_in "Tipo", with: @tar_servicio.tipo
    click_on "Update Tar servicio"

    assert_text "Tar servicio was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar servicio" do
    visit tar_servicios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar servicio was successfully destroyed"
  end
end
