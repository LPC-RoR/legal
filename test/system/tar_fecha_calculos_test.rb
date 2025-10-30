require "application_system_test_case"

class TarFechaCalculosTest < ApplicationSystemTestCase
  setup do
    @tar_fecha_calculo = tar_fecha_calculos(:one)
  end

  test "visiting the index" do
    visit tar_fecha_calculos_url
    assert_selector "h1", text: "Tar fecha calculos"
  end

  test "should create tar fecha calculo" do
    visit tar_fecha_calculos_url
    click_on "New tar fecha calculo"

    fill_in "Codigo formula", with: @tar_fecha_calculo.codigo_formula
    fill_in "Fecha", with: @tar_fecha_calculo.fecha
    fill_in "Ownr", with: @tar_fecha_calculo.ownr_id
    fill_in "Ownr type", with: @tar_fecha_calculo.ownr_type
    click_on "Create Tar fecha calculo"

    assert_text "Tar fecha calculo was successfully created"
    click_on "Back"
  end

  test "should update Tar fecha calculo" do
    visit tar_fecha_calculo_url(@tar_fecha_calculo)
    click_on "Edit this tar fecha calculo", match: :first

    fill_in "Codigo formula", with: @tar_fecha_calculo.codigo_formula
    fill_in "Fecha", with: @tar_fecha_calculo.fecha
    fill_in "Ownr", with: @tar_fecha_calculo.ownr_id
    fill_in "Ownr type", with: @tar_fecha_calculo.ownr_type
    click_on "Update Tar fecha calculo"

    assert_text "Tar fecha calculo was successfully updated"
    click_on "Back"
  end

  test "should destroy Tar fecha calculo" do
    visit tar_fecha_calculo_url(@tar_fecha_calculo)
    click_on "Destroy this tar fecha calculo", match: :first

    assert_text "Tar fecha calculo was successfully destroyed"
  end
end
