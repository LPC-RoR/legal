require "application_system_test_case"

class TarCuotasTest < ApplicationSystemTestCase
  setup do
    @tar_cuota = tar_cuotas(:one)
  end

  test "visiting the index" do
    visit tar_cuotas_url
    assert_selector "h1", text: "Tar Cuotas"
  end

  test "creating a Tar cuota" do
    visit tar_cuotas_url
    click_on "New Tar Cuota"

    fill_in "Moneda", with: @tar_cuota.moneda
    fill_in "Monto", with: @tar_cuota.monto
    fill_in "Orden", with: @tar_cuota.orden
    fill_in "Porcentaje", with: @tar_cuota.porcentaje
    fill_in "Tar cuota", with: @tar_cuota.tar_cuota
    fill_in "Tar pago", with: @tar_cuota.tar_pago_id
    check "Ultima cuota" if @tar_cuota.ultima_cuota
    click_on "Create Tar cuota"

    assert_text "Tar cuota was successfully created"
    click_on "Back"
  end

  test "updating a Tar cuota" do
    visit tar_cuotas_url
    click_on "Edit", match: :first

    fill_in "Moneda", with: @tar_cuota.moneda
    fill_in "Monto", with: @tar_cuota.monto
    fill_in "Orden", with: @tar_cuota.orden
    fill_in "Porcentaje", with: @tar_cuota.porcentaje
    fill_in "Tar cuota", with: @tar_cuota.tar_cuota
    fill_in "Tar pago", with: @tar_cuota.tar_pago_id
    check "Ultima cuota" if @tar_cuota.ultima_cuota
    click_on "Update Tar cuota"

    assert_text "Tar cuota was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar cuota" do
    visit tar_cuotas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar cuota was successfully destroyed"
  end
end
