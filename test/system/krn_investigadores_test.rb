require "application_system_test_case"

class KrnInvestigadoresTest < ApplicationSystemTestCase
  setup do
    @krn_investigador = krn_investigadores(:one)
  end

  test "visiting the index" do
    visit krn_investigadores_url
    assert_selector "h1", text: "Krn investigadores"
  end

  test "should create krn investigador" do
    visit krn_investigadores_url
    click_on "New krn investigador"

    fill_in "Email", with: @krn_investigador.email
    fill_in "Krn investigador", with: @krn_investigador.krn_investigador
    fill_in "Rut", with: @krn_investigador.rut
    click_on "Create Krn investigador"

    assert_text "Krn investigador was successfully created"
    click_on "Back"
  end

  test "should update Krn investigador" do
    visit krn_investigador_url(@krn_investigador)
    click_on "Edit this krn investigador", match: :first

    fill_in "Email", with: @krn_investigador.email
    fill_in "Krn investigador", with: @krn_investigador.krn_investigador
    fill_in "Rut", with: @krn_investigador.rut
    click_on "Update Krn investigador"

    assert_text "Krn investigador was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn investigador" do
    visit krn_investigador_url(@krn_investigador)
    click_on "Destroy this krn investigador", match: :first

    assert_text "Krn investigador was successfully destroyed"
  end
end
