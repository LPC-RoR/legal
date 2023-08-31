require "application_system_test_case"

class DtTablaMultasTest < ApplicationSystemTestCase
  setup do
    @dt_tabla_multa = dt_tabla_multas(:one)
  end

  test "visiting the index" do
    visit dt_tabla_multas_url
    assert_selector "h1", text: "Dt Tabla Multas"
  end

  test "creating a Dt tabla multa" do
    visit dt_tabla_multas_url
    click_on "New Dt Tabla Multa"

    fill_in "Dt tabla multa", with: @dt_tabla_multa.dt_tabla_multa
    click_on "Create Dt tabla multa"

    assert_text "Dt tabla multa was successfully created"
    click_on "Back"
  end

  test "updating a Dt tabla multa" do
    visit dt_tabla_multas_url
    click_on "Edit", match: :first

    fill_in "Dt tabla multa", with: @dt_tabla_multa.dt_tabla_multa
    click_on "Update Dt tabla multa"

    assert_text "Dt tabla multa was successfully updated"
    click_on "Back"
  end

  test "destroying a Dt tabla multa" do
    visit dt_tabla_multas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dt tabla multa was successfully destroyed"
  end
end
