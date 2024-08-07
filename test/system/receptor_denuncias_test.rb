require "application_system_test_case"

class ReceptorDenunciasTest < ApplicationSystemTestCase
  setup do
    @receptor_denuncia = receptor_denuncias(:one)
  end

  test "visiting the index" do
    visit receptor_denuncias_url
    assert_selector "h1", text: "Receptor denuncias"
  end

  test "should create receptor denuncia" do
    visit receptor_denuncias_url
    click_on "New receptor denuncia"

    fill_in "Receptor denuncia", with: @receptor_denuncia.receptor_denuncia
    click_on "Create Receptor denuncia"

    assert_text "Receptor denuncia was successfully created"
    click_on "Back"
  end

  test "should update Receptor denuncia" do
    visit receptor_denuncia_url(@receptor_denuncia)
    click_on "Edit this receptor denuncia", match: :first

    fill_in "Receptor denuncia", with: @receptor_denuncia.receptor_denuncia
    click_on "Update Receptor denuncia"

    assert_text "Receptor denuncia was successfully updated"
    click_on "Back"
  end

  test "should destroy Receptor denuncia" do
    visit receptor_denuncia_url(@receptor_denuncia)
    click_on "Destroy this receptor denuncia", match: :first

    assert_text "Receptor denuncia was successfully destroyed"
  end
end
