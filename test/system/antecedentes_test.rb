require "application_system_test_case"

class AntecedentesTest < ApplicationSystemTestCase
  setup do
    @antecedente = antecedentes(:one)
  end

  test "visiting the index" do
    visit antecedentes_url
    assert_selector "h1", text: "Antecedentes"
  end

  test "creating a Antecedente" do
    visit antecedentes_url
    click_on "New Antecedente"

    fill_in "Causa", with: @antecedente.causa_id
    fill_in "Cita", with: @antecedente.cita
    fill_in "Hecho", with: @antecedente.hecho
    fill_in "Orden", with: @antecedente.orden
    fill_in "Riesgo", with: @antecedente.riesgo
    fill_in "Ventaja", with: @antecedente.ventaja
    click_on "Create Antecedente"

    assert_text "Antecedente was successfully created"
    click_on "Back"
  end

  test "updating a Antecedente" do
    visit antecedentes_url
    click_on "Edit", match: :first

    fill_in "Causa", with: @antecedente.causa_id
    fill_in "Cita", with: @antecedente.cita
    fill_in "Hecho", with: @antecedente.hecho
    fill_in "Orden", with: @antecedente.orden
    fill_in "Riesgo", with: @antecedente.riesgo
    fill_in "Ventaja", with: @antecedente.ventaja
    click_on "Update Antecedente"

    assert_text "Antecedente was successfully updated"
    click_on "Back"
  end

  test "destroying a Antecedente" do
    visit antecedentes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Antecedente was successfully destroyed"
  end
end
