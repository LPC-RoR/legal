require "application_system_test_case"

class KrnLstMedidasTest < ApplicationSystemTestCase
  setup do
    @krn_lst_medida = krn_lst_medidas(:one)
  end

  test "visiting the index" do
    visit krn_lst_medidas_url
    assert_selector "h1", text: "Krn lst medidas"
  end

  test "should create krn lst medida" do
    visit krn_lst_medidas_url
    click_on "New krn lst medida"

    fill_in "Emisor", with: @krn_lst_medida.emisor
    fill_in "Ownr", with: @krn_lst_medida.ownr_id
    fill_in "Ownr type", with: @krn_lst_medida.ownr_type
    fill_in "Tipo", with: @krn_lst_medida.tipo
    click_on "Create Krn lst medida"

    assert_text "Krn lst medida was successfully created"
    click_on "Back"
  end

  test "should update Krn lst medida" do
    visit krn_lst_medida_url(@krn_lst_medida)
    click_on "Edit this krn lst medida", match: :first

    fill_in "Emisor", with: @krn_lst_medida.emisor
    fill_in "Ownr", with: @krn_lst_medida.ownr_id
    fill_in "Ownr type", with: @krn_lst_medida.ownr_type
    fill_in "Tipo", with: @krn_lst_medida.tipo
    click_on "Update Krn lst medida"

    assert_text "Krn lst medida was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn lst medida" do
    visit krn_lst_medida_url(@krn_lst_medida)
    click_on "Destroy this krn lst medida", match: :first

    assert_text "Krn lst medida was successfully destroyed"
  end
end
