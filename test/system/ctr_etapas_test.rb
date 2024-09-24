require "application_system_test_case"

class CtrEtapasTest < ApplicationSystemTestCase
  setup do
    @ctr_etapa = ctr_etapas(:one)
  end

  test "visiting the index" do
    visit ctr_etapas_url
    assert_selector "h1", text: "Ctr etapas"
  end

  test "should create ctr etapa" do
    visit ctr_etapas_url
    click_on "New ctr etapa"

    fill_in "Codigo", with: @ctr_etapa.codigo
    fill_in "Ctr etapa", with: @ctr_etapa.ctr_etapa
    fill_in "Procedimiento", with: @ctr_etapa.procedimiento_id
    click_on "Create Ctr etapa"

    assert_text "Ctr etapa was successfully created"
    click_on "Back"
  end

  test "should update Ctr etapa" do
    visit ctr_etapa_url(@ctr_etapa)
    click_on "Edit this ctr etapa", match: :first

    fill_in "Codigo", with: @ctr_etapa.codigo
    fill_in "Ctr etapa", with: @ctr_etapa.ctr_etapa
    fill_in "Procedimiento", with: @ctr_etapa.procedimiento_id
    click_on "Update Ctr etapa"

    assert_text "Ctr etapa was successfully updated"
    click_on "Back"
  end

  test "should destroy Ctr etapa" do
    visit ctr_etapa_url(@ctr_etapa)
    click_on "Destroy this ctr etapa", match: :first

    assert_text "Ctr etapa was successfully destroyed"
  end
end
