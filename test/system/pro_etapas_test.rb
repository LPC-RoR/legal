require "application_system_test_case"

class ProEtapasTest < ApplicationSystemTestCase
  setup do
    @pro_etapa = pro_etapas(:one)
  end

  test "visiting the index" do
    visit pro_etapas_url
    assert_selector "h1", text: "Pro etapas"
  end

  test "should create pro etapa" do
    visit pro_etapas_url
    click_on "New pro etapa"

    fill_in "Code descripcion", with: @pro_etapa.code_descripcion
    fill_in "Estado", with: @pro_etapa.estado
    fill_in "Orden", with: @pro_etapa.orden
    fill_in "Pro etapa", with: @pro_etapa.pro_etapa
    fill_in "Producto", with: @pro_etapa.producto_id
    click_on "Create Pro etapa"

    assert_text "Pro etapa was successfully created"
    click_on "Back"
  end

  test "should update Pro etapa" do
    visit pro_etapa_url(@pro_etapa)
    click_on "Edit this pro etapa", match: :first

    fill_in "Code descripcion", with: @pro_etapa.code_descripcion
    fill_in "Estado", with: @pro_etapa.estado
    fill_in "Orden", with: @pro_etapa.orden
    fill_in "Pro etapa", with: @pro_etapa.pro_etapa
    fill_in "Producto", with: @pro_etapa.producto_id
    click_on "Update Pro etapa"

    assert_text "Pro etapa was successfully updated"
    click_on "Back"
  end

  test "should destroy Pro etapa" do
    visit pro_etapa_url(@pro_etapa)
    click_on "Destroy this pro etapa", match: :first

    assert_text "Pro etapa was successfully destroyed"
  end
end
