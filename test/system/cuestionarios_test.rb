require "application_system_test_case"

class CuestionariosTest < ApplicationSystemTestCase
  setup do
    @cuestionario = cuestionarios(:one)
  end

  test "visiting the index" do
    visit cuestionarios_url
    assert_selector "h1", text: "Cuestionarios"
  end

  test "should create cuestionario" do
    visit cuestionarios_url
    click_on "New cuestionario"

    fill_in "Cuestionario", with: @cuestionario.cuestionario
    fill_in "Orden", with: @cuestionario.orden
    fill_in "Pauta", with: @cuestionario.pauta_id
    fill_in "Referencia", with: @cuestionario.referencia
    click_on "Create Cuestionario"

    assert_text "Cuestionario was successfully created"
    click_on "Back"
  end

  test "should update Cuestionario" do
    visit cuestionario_url(@cuestionario)
    click_on "Edit this cuestionario", match: :first

    fill_in "Cuestionario", with: @cuestionario.cuestionario
    fill_in "Orden", with: @cuestionario.orden
    fill_in "Pauta", with: @cuestionario.pauta_id
    fill_in "Referencia", with: @cuestionario.referencia
    click_on "Update Cuestionario"

    assert_text "Cuestionario was successfully updated"
    click_on "Back"
  end

  test "should destroy Cuestionario" do
    visit cuestionario_url(@cuestionario)
    click_on "Destroy this cuestionario", match: :first

    assert_text "Cuestionario was successfully destroyed"
  end
end
