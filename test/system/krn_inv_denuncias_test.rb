require "application_system_test_case"

class KrnInvDenunciasTest < ApplicationSystemTestCase
  setup do
    @krn_inv_denuncia = krn_inv_denuncias(:one)
  end

  test "visiting the index" do
    visit krn_inv_denuncias_url
    assert_selector "h1", text: "Krn inv denuncias"
  end

  test "should create krn inv denuncia" do
    visit krn_inv_denuncias_url
    click_on "New krn inv denuncia"

    fill_in "Krn denuncia", with: @krn_inv_denuncia.krn_denuncia_id
    fill_in "Krn investigador", with: @krn_inv_denuncia.krn_investigador_id
    click_on "Create Krn inv denuncia"

    assert_text "Krn inv denuncia was successfully created"
    click_on "Back"
  end

  test "should update Krn inv denuncia" do
    visit krn_inv_denuncia_url(@krn_inv_denuncia)
    click_on "Edit this krn inv denuncia", match: :first

    fill_in "Krn denuncia", with: @krn_inv_denuncia.krn_denuncia_id
    fill_in "Krn investigador", with: @krn_inv_denuncia.krn_investigador_id
    click_on "Update Krn inv denuncia"

    assert_text "Krn inv denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn inv denuncia" do
    visit krn_inv_denuncia_url(@krn_inv_denuncia)
    click_on "Destroy this krn inv denuncia", match: :first

    assert_text "Krn inv denuncia was successfully destroyed"
  end
end
