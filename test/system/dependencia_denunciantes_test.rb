require "application_system_test_case"

class DependenciaDenunciantesTest < ApplicationSystemTestCase
  setup do
    @dependencia_denunciante = dependencia_denunciantes(:one)
  end

  test "visiting the index" do
    visit dependencia_denunciantes_url
    assert_selector "h1", text: "Dependencia denunciantes"
  end

  test "should create dependencia denunciante" do
    visit dependencia_denunciantes_url
    click_on "New dependencia denunciante"

    fill_in "Dependencia denunciante", with: @dependencia_denunciante.dependencia_denunciante
    click_on "Create Dependencia denunciante"

    assert_text "Dependencia denunciante was successfully created"
    click_on "Back"
  end

  test "should update Dependencia denunciante" do
    visit dependencia_denunciante_url(@dependencia_denunciante)
    click_on "Edit this dependencia denunciante", match: :first

    fill_in "Dependencia denunciante", with: @dependencia_denunciante.dependencia_denunciante
    click_on "Update Dependencia denunciante"

    assert_text "Dependencia denunciante was successfully updated"
    click_on "Back"
  end

  test "should destroy Dependencia denunciante" do
    visit dependencia_denunciante_url(@dependencia_denunciante)
    click_on "Destroy this dependencia denunciante", match: :first

    assert_text "Dependencia denunciante was successfully destroyed"
  end
end
