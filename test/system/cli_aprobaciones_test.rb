require "application_system_test_case"

class CliAprobacionesTest < ApplicationSystemTestCase
  setup do
    @cli_aprobacion = cli_aprobaciones(:one)
  end

  test "visiting the index" do
    visit cli_aprobaciones_url
    assert_selector "h1", text: "Cli aprobaciones"
  end

  test "should create cli aprobacion" do
    visit cli_aprobaciones_url
    click_on "New cli aprobacion"

    fill_in "Fecha", with: @cli_aprobacion.fecha
    click_on "Create Cli aprobacion"

    assert_text "Cli aprobacion was successfully created"
    click_on "Back"
  end

  test "should update Cli aprobacion" do
    visit cli_aprobacion_url(@cli_aprobacion)
    click_on "Edit this cli aprobacion", match: :first

    fill_in "Fecha", with: @cli_aprobacion.fecha
    click_on "Update Cli aprobacion"

    assert_text "Cli aprobacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Cli aprobacion" do
    visit cli_aprobacion_url(@cli_aprobacion)
    click_on "Destroy this cli aprobacion", match: :first

    assert_text "Cli aprobacion was successfully destroyed"
  end
end
