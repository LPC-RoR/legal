require "application_system_test_case"

class DemandantesTest < ApplicationSystemTestCase
  setup do
    @demandante = demandantes(:one)
  end

  test "visiting the index" do
    visit demandantes_url
    assert_selector "h1", text: "Demandantes"
  end

  test "should create demandante" do
    visit demandantes_url
    click_on "New demandante"

    fill_in "Apellidos", with: @demandante.apellidos
    fill_in "Cargo", with: @demandante.cargo
    fill_in "Causa", with: @demandante.causa_id
    fill_in "Lugar trabajo", with: @demandante.lugar_trabajo
    fill_in "Nombres", with: @demandante.nombres
    fill_in "Orden", with: @demandante.orden
    fill_in "Remuneracion", with: @demandante.remuneracion
    click_on "Create Demandante"

    assert_text "Demandante was successfully created"
    click_on "Back"
  end

  test "should update Demandante" do
    visit demandante_url(@demandante)
    click_on "Edit this demandante", match: :first

    fill_in "Apellidos", with: @demandante.apellidos
    fill_in "Cargo", with: @demandante.cargo
    fill_in "Causa", with: @demandante.causa_id
    fill_in "Lugar trabajo", with: @demandante.lugar_trabajo
    fill_in "Nombres", with: @demandante.nombres
    fill_in "Orden", with: @demandante.orden
    fill_in "Remuneracion", with: @demandante.remuneracion
    click_on "Update Demandante"

    assert_text "Demandante was successfully updated"
    click_on "Back"
  end

  test "should destroy Demandante" do
    visit demandante_url(@demandante)
    click_on "Destroy this demandante", match: :first

    assert_text "Demandante was successfully destroyed"
  end
end
