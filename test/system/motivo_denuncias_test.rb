require "application_system_test_case"

class MotivoDenunciasTest < ApplicationSystemTestCase
  setup do
    @motivo_denuncia = motivo_denuncias(:one)
  end

  test "visiting the index" do
    visit motivo_denuncias_url
    assert_selector "h1", text: "Motivo denuncias"
  end

  test "should create motivo denuncia" do
    visit motivo_denuncias_url
    click_on "New motivo denuncia"

    fill_in "Motivo denuncia", with: @motivo_denuncia.motivo_denuncia
    click_on "Create Motivo denuncia"

    assert_text "Motivo denuncia was successfully created"
    click_on "Back"
  end

  test "should update Motivo denuncia" do
    visit motivo_denuncia_url(@motivo_denuncia)
    click_on "Edit this motivo denuncia", match: :first

    fill_in "Motivo denuncia", with: @motivo_denuncia.motivo_denuncia
    click_on "Update Motivo denuncia"

    assert_text "Motivo denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Motivo denuncia" do
    visit motivo_denuncia_url(@motivo_denuncia)
    click_on "Destroy this motivo denuncia", match: :first

    assert_text "Motivo denuncia was successfully destroyed"
  end
end
