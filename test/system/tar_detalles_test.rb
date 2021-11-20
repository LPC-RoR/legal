require "application_system_test_case"

class TarDetallesTest < ApplicationSystemTestCase
  setup do
    @tar_detalle = tar_detalles(:one)
  end

  test "visiting the index" do
    visit tar_detalles_url
    assert_selector "h1", text: "Tar Detalles"
  end

  test "creating a Tar detalle" do
    visit tar_detalles_url
    click_on "New Tar Detalle"

    fill_in "Codigo", with: @tar_detalle.codigo
    fill_in "Detalle", with: @tar_detalle.detalle
    fill_in "Formula", with: @tar_detalle.formula
    fill_in "Orden", with: @tar_detalle.orden
    fill_in "Tar tarifa", with: @tar_detalle.tar_tarifa_id
    fill_in "Tipo", with: @tar_detalle.tipo
    click_on "Create Tar detalle"

    assert_text "Tar detalle was successfully created"
    click_on "Back"
  end

  test "updating a Tar detalle" do
    visit tar_detalles_url
    click_on "Edit", match: :first

    fill_in "Codigo", with: @tar_detalle.codigo
    fill_in "Detalle", with: @tar_detalle.detalle
    fill_in "Formula", with: @tar_detalle.formula
    fill_in "Orden", with: @tar_detalle.orden
    fill_in "Tar tarifa", with: @tar_detalle.tar_tarifa_id
    fill_in "Tipo", with: @tar_detalle.tipo
    click_on "Update Tar detalle"

    assert_text "Tar detalle was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar detalle" do
    visit tar_detalles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar detalle was successfully destroyed"
  end
end
