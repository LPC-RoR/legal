require "application_system_test_case"

class CtrRegistrosTest < ApplicationSystemTestCase
  setup do
    @ctr_registro = ctr_registros(:one)
  end

  test "visiting the index" do
    visit ctr_registros_url
    assert_selector "h1", text: "Ctr registros"
  end

  test "should create ctr registro" do
    visit ctr_registros_url
    click_on "New ctr registro"

    fill_in "Ctr paso", with: @ctr_registro.ctr_paso_id
    fill_in "Fecha", with: @ctr_registro.fecha
    fill_in "Glosa", with: @ctr_registro.glosa
    fill_in "Ownr", with: @ctr_registro.ownr_id
    fill_in "Ownr type", with: @ctr_registro.ownr_type
    fill_in "Tarea", with: @ctr_registro.tarea_id
    fill_in "Valor", with: @ctr_registro.valor
    click_on "Create Ctr registro"

    assert_text "Ctr registro was successfully created"
    click_on "Back"
  end

  test "should update Ctr registro" do
    visit ctr_registro_url(@ctr_registro)
    click_on "Edit this ctr registro", match: :first

    fill_in "Ctr paso", with: @ctr_registro.ctr_paso_id
    fill_in "Fecha", with: @ctr_registro.fecha.to_s
    fill_in "Glosa", with: @ctr_registro.glosa
    fill_in "Ownr", with: @ctr_registro.ownr_id
    fill_in "Ownr type", with: @ctr_registro.ownr_type
    fill_in "Tarea", with: @ctr_registro.tarea_id
    fill_in "Valor", with: @ctr_registro.valor
    click_on "Update Ctr registro"

    assert_text "Ctr registro was successfully updated"
    click_on "Back"
  end

  test "should destroy Ctr registro" do
    visit ctr_registro_url(@ctr_registro)
    click_on "Destroy this ctr registro", match: :first

    assert_text "Ctr registro was successfully destroyed"
  end
end
