require "application_system_test_case"

class TarPagosTest < ApplicationSystemTestCase
  setup do
    @tar_pago = tar_pagos(:one)
  end

  test "visiting the index" do
    visit tar_pagos_url
    assert_selector "h1", text: "Tar Pagos"
  end

  test "creating a Tar pago" do
    visit tar_pagos_url
    click_on "New Tar Pago"

    fill_in "Estado", with: @tar_pago.estado
    fill_in "Moneda", with: @tar_pago.moneda
    fill_in "Tar pago", with: @tar_pago.tar_pago
    fill_in "Tar tarifa", with: @tar_pago.tar_tarifa_id
    fill_in "Valor", with: @tar_pago.valor
    click_on "Create Tar pago"

    assert_text "Tar pago was successfully created"
    click_on "Back"
  end

  test "updating a Tar pago" do
    visit tar_pagos_url
    click_on "Edit", match: :first

    fill_in "Estado", with: @tar_pago.estado
    fill_in "Moneda", with: @tar_pago.moneda
    fill_in "Tar pago", with: @tar_pago.tar_pago
    fill_in "Tar tarifa", with: @tar_pago.tar_tarifa_id
    fill_in "Valor", with: @tar_pago.valor
    click_on "Update Tar pago"

    assert_text "Tar pago was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar pago" do
    visit tar_pagos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar pago was successfully destroyed"
  end
end
