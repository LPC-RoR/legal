require "application_system_test_case"

class StModelosTest < ApplicationSystemTestCase
  setup do
    @st_modelo = st_modelos(:one)
  end

  test "visiting the index" do
    visit st_modelos_url
    assert_selector "h1", text: "St Modelos"
  end

  test "creating a St modelo" do
    visit st_modelos_url
    click_on "New St Modelo"

    fill_in "St modelo", with: @st_modelo.st_modelo
    click_on "Create St modelo"

    assert_text "St modelo was successfully created"
    click_on "Back"
  end

  test "updating a St modelo" do
    visit st_modelos_url
    click_on "Edit", match: :first

    fill_in "St modelo", with: @st_modelo.st_modelo
    click_on "Update St modelo"

    assert_text "St modelo was successfully updated"
    click_on "Back"
  end

  test "destroying a St modelo" do
    visit st_modelos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "St modelo was successfully destroyed"
  end
end
