require "application_system_test_case"

class ComunasTest < ApplicationSystemTestCase
  setup do
    @comuna = comunas(:one)
  end

  test "visiting the index" do
    visit comunas_url
    assert_selector "h1", text: "Comunas"
  end

  test "creating a Comuna" do
    visit comunas_url
    click_on "New Comuna"

    fill_in "Comuna", with: @comuna.comuna
    fill_in "Region", with: @comuna.region_id
    click_on "Create Comuna"

    assert_text "Comuna was successfully created"
    click_on "Back"
  end

  test "updating a Comuna" do
    visit comunas_url
    click_on "Edit", match: :first

    fill_in "Comuna", with: @comuna.comuna
    fill_in "Region", with: @comuna.region_id
    click_on "Update Comuna"

    assert_text "Comuna was successfully updated"
    click_on "Back"
  end

  test "destroying a Comuna" do
    visit comunas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Comuna was successfully destroyed"
  end
end
