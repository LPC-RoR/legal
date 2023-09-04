require "application_system_test_case"

class DtCriterioMultasTest < ApplicationSystemTestCase
  setup do
    @dt_criterio_multa = dt_criterio_multas(:one)
  end

  test "visiting the index" do
    visit dt_criterio_multas_url
    assert_selector "h1", text: "Dt Criterio Multas"
  end

  test "creating a Dt criterio multa" do
    visit dt_criterio_multas_url
    click_on "New Dt Criterio Multa"

    fill_in "Dt criterio multa", with: @dt_criterio_multa.dt_criterio_multa
    fill_in "Dt tabla multa", with: @dt_criterio_multa.dt_tabla_multa_id
    fill_in "Monto", with: @dt_criterio_multa.monto
    fill_in "Orden", with: @dt_criterio_multa.orden
    fill_in "Unidad", with: @dt_criterio_multa.unidad
    click_on "Create Dt criterio multa"

    assert_text "Dt criterio multa was successfully created"
    click_on "Back"
  end

  test "updating a Dt criterio multa" do
    visit dt_criterio_multas_url
    click_on "Edit", match: :first

    fill_in "Dt criterio multa", with: @dt_criterio_multa.dt_criterio_multa
    fill_in "Dt tabla multa", with: @dt_criterio_multa.dt_tabla_multa_id
    fill_in "Monto", with: @dt_criterio_multa.monto
    fill_in "Orden", with: @dt_criterio_multa.orden
    fill_in "Unidad", with: @dt_criterio_multa.unidad
    click_on "Update Dt criterio multa"

    assert_text "Dt criterio multa was successfully updated"
    click_on "Back"
  end

  test "destroying a Dt criterio multa" do
    visit dt_criterio_multas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dt criterio multa was successfully destroyed"
  end
end
