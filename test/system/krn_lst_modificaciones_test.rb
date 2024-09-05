require "application_system_test_case"

class KrnLstModificacionesTest < ApplicationSystemTestCase
  setup do
    @krn_lst_modificacion = krn_lst_modificaciones(:one)
  end

  test "visiting the index" do
    visit krn_lst_modificaciones_url
    assert_selector "h1", text: "Krn lst modificaciones"
  end

  test "should create krn lst modificacion" do
    visit krn_lst_modificaciones_url
    click_on "New krn lst modificacion"

    fill_in "Emisor", with: @krn_lst_modificacion.emisor
    fill_in "Ownr", with: @krn_lst_modificacion.ownr_id
    fill_in "Ownr type", with: @krn_lst_modificacion.ownr_type
    click_on "Create Krn lst modificacion"

    assert_text "Krn lst modificacion was successfully created"
    click_on "Back"
  end

  test "should update Krn lst modificacion" do
    visit krn_lst_modificacion_url(@krn_lst_modificacion)
    click_on "Edit this krn lst modificacion", match: :first

    fill_in "Emisor", with: @krn_lst_modificacion.emisor
    fill_in "Ownr", with: @krn_lst_modificacion.ownr_id
    fill_in "Ownr type", with: @krn_lst_modificacion.ownr_type
    click_on "Update Krn lst modificacion"

    assert_text "Krn lst modificacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn lst modificacion" do
    visit krn_lst_modificacion_url(@krn_lst_modificacion)
    click_on "Destroy this krn lst modificacion", match: :first

    assert_text "Krn lst modificacion was successfully destroyed"
  end
end
