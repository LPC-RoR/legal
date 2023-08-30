require "application_system_test_case"

class DtMultasTest < ApplicationSystemTestCase
  setup do
    @dt_multa = dt_multas(:one)
  end

  test "visiting the index" do
    visit dt_multas_url
    assert_selector "h1", text: "Dt Multas"
  end

  test "creating a Dt multa" do
    visit dt_multas_url
    click_on "New Dt Multa"

    fill_in "Grave", with: @dt_multa.grave
    fill_in "Gravisima", with: @dt_multa.gravisima
    fill_in "Leve", with: @dt_multa.leve
    fill_in "Orden", with: @dt_multa.orden
    fill_in "Tamanio", with: @dt_multa.tamanio
    click_on "Create Dt multa"

    assert_text "Dt multa was successfully created"
    click_on "Back"
  end

  test "updating a Dt multa" do
    visit dt_multas_url
    click_on "Edit", match: :first

    fill_in "Grave", with: @dt_multa.grave
    fill_in "Gravisima", with: @dt_multa.gravisima
    fill_in "Leve", with: @dt_multa.leve
    fill_in "Orden", with: @dt_multa.orden
    fill_in "Tamanio", with: @dt_multa.tamanio
    click_on "Update Dt multa"

    assert_text "Dt multa was successfully updated"
    click_on "Back"
  end

  test "destroying a Dt multa" do
    visit dt_multas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dt multa was successfully destroyed"
  end
end
