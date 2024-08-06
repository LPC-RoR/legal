require "application_system_test_case"

class TipoDenunciasTest < ApplicationSystemTestCase
  setup do
    @tipo_denuncia = tipo_denuncias(:one)
  end

  test "visiting the index" do
    visit tipo_denuncias_url
    assert_selector "h1", text: "Tipo denuncias"
  end

  test "should create tipo denuncia" do
    visit tipo_denuncias_url
    click_on "New tipo denuncia"

    fill_in "Tipo denuncia", with: @tipo_denuncia.tipo_denuncia
    click_on "Create Tipo denuncia"

    assert_text "Tipo denuncia was successfully created"
    click_on "Back"
  end

  test "should update Tipo denuncia" do
    visit tipo_denuncia_url(@tipo_denuncia)
    click_on "Edit this tipo denuncia", match: :first

    fill_in "Tipo denuncia", with: @tipo_denuncia.tipo_denuncia
    click_on "Update Tipo denuncia"

    assert_text "Tipo denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Tipo denuncia" do
    visit tipo_denuncia_url(@tipo_denuncia)
    click_on "Destroy this tipo denuncia", match: :first

    assert_text "Tipo denuncia was successfully destroyed"
  end
end
