require "application_system_test_case"

class CheckFuentesTest < ApplicationSystemTestCase
  setup do
    @check_fuente = check_fuentes(:one)
  end

  test "visiting the index" do
    visit check_fuentes_url
    assert_selector "h1", text: "Check fuentes"
  end

  test "should create check fuente" do
    visit check_fuentes_url
    click_on "New check fuente"

    fill_in "Check realizado", with: @check_fuente.check_realizado_id
    fill_in "Fecha", with: @check_fuente.fecha
    fill_in "Fuente", with: @check_fuente.fuente
    fill_in "Usuario", with: @check_fuente.usuario_id
    click_on "Create Check fuente"

    assert_text "Check fuente was successfully created"
    click_on "Back"
  end

  test "should update Check fuente" do
    visit check_fuente_url(@check_fuente)
    click_on "Edit this check fuente", match: :first

    fill_in "Check realizado", with: @check_fuente.check_realizado_id
    fill_in "Fecha", with: @check_fuente.fecha.to_s
    fill_in "Fuente", with: @check_fuente.fuente
    fill_in "Usuario", with: @check_fuente.usuario_id
    click_on "Update Check fuente"

    assert_text "Check fuente was successfully updated"
    click_on "Back"
  end

  test "should destroy Check fuente" do
    visit check_fuente_url(@check_fuente)
    click_on "Destroy this check fuente", match: :first

    assert_text "Check fuente was successfully destroyed"
  end
end
