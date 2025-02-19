require "application_system_test_case"

class ModelosTest < ApplicationSystemTestCase
  setup do
    @modelo = modelos(:one)
  end

  test "visiting the index" do
    visit modelos_url
    assert_selector "h1", text: "Modelos"
  end

  test "should create modelo" do
    visit modelos_url
    click_on "New modelo"

    click_on "Create Modelo"

    assert_text "Modelo was successfully created"
    click_on "Back"
  end

  test "should update Modelo" do
    visit modelo_url(@modelo)
    click_on "Edit this modelo", match: :first

    click_on "Update Modelo"

    assert_text "Modelo was successfully updated"
    click_on "Back"
  end

  test "should destroy Modelo" do
    visit modelo_url(@modelo)
    click_on "Destroy this modelo", match: :first

    assert_text "Modelo was successfully destroyed"
  end
end
