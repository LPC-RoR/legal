require "application_system_test_case"

class TipoDenunciadosTest < ApplicationSystemTestCase
  setup do
    @tipo_denunciado = tipo_denunciados(:one)
  end

  test "visiting the index" do
    visit tipo_denunciados_url
    assert_selector "h1", text: "Tipo denunciados"
  end

  test "should create tipo denunciado" do
    visit tipo_denunciados_url
    click_on "New tipo denunciado"

    fill_in "Tipo denunciado", with: @tipo_denunciado.tipo_denunciado
    click_on "Create Tipo denunciado"

    assert_text "Tipo denunciado was successfully created"
    click_on "Back"
  end

  test "should update Tipo denunciado" do
    visit tipo_denunciado_url(@tipo_denunciado)
    click_on "Edit this tipo denunciado", match: :first

    fill_in "Tipo denunciado", with: @tipo_denunciado.tipo_denunciado
    click_on "Update Tipo denunciado"

    assert_text "Tipo denunciado was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipo denunciado" do
    visit tipo_denunciado_url(@tipo_denunciado)
    click_on "Destroy this tipo denunciado", match: :first

    assert_text "Tipo denunciado was successfully destroyed"
  end
end
