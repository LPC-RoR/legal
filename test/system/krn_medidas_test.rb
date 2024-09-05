require "application_system_test_case"

class KrnMedidasTest < ApplicationSystemTestCase
  setup do
    @krn_medida = krn_medidas(:one)
  end

  test "visiting the index" do
    visit krn_medidas_url
    assert_selector "h1", text: "Krn medidas"
  end

  test "should create krn medida" do
    visit krn_medidas_url
    click_on "New krn medida"

    fill_in "Detalle", with: @krn_medida.detalle
    fill_in "Krn lst medida", with: @krn_medida.krn_lst_medida_id
    fill_in "Krn medida", with: @krn_medida.krn_medida
    fill_in "Krn tipo medida", with: @krn_medida.krn_tipo_medida_id
    click_on "Create Krn medida"

    assert_text "Krn medida was successfully created"
    click_on "Back"
  end

  test "should update Krn medida" do
    visit krn_medida_url(@krn_medida)
    click_on "Edit this krn medida", match: :first

    fill_in "Detalle", with: @krn_medida.detalle
    fill_in "Krn lst medida", with: @krn_medida.krn_lst_medida_id
    fill_in "Krn medida", with: @krn_medida.krn_medida
    fill_in "Krn tipo medida", with: @krn_medida.krn_tipo_medida_id
    click_on "Update Krn medida"

    assert_text "Krn medida was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn medida" do
    visit krn_medida_url(@krn_medida)
    click_on "Destroy this krn medida", match: :first

    assert_text "Krn medida was successfully destroyed"
  end
end
