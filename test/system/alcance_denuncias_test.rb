require "application_system_test_case"

class AlcanceDenunciasTest < ApplicationSystemTestCase
  setup do
    @alcance_denuncia = alcance_denuncias(:one)
  end

  test "visiting the index" do
    visit alcance_denuncias_url
    assert_selector "h1", text: "Alcance denuncias"
  end

  test "should create alcance denuncia" do
    visit alcance_denuncias_url
    click_on "New alcance denuncia"

    fill_in "Alcance denuncia", with: @alcance_denuncia.alcance_denuncia
    click_on "Create Alcance denuncia"

    assert_text "Alcance denuncia was successfully created"
    click_on "Back"
  end

  test "should update Alcance denuncia" do
    visit alcance_denuncia_url(@alcance_denuncia)
    click_on "Edit this alcance denuncia", match: :first

    fill_in "Alcance denuncia", with: @alcance_denuncia.alcance_denuncia
    click_on "Update Alcance denuncia"

    assert_text "Alcance denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Alcance denuncia" do
    visit alcance_denuncia_url(@alcance_denuncia)
    click_on "Destroy this alcance denuncia", match: :first

    assert_text "Alcance denuncia was successfully destroyed"
  end
end
