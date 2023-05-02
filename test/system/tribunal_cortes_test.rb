require "application_system_test_case"

class TribunalCortesTest < ApplicationSystemTestCase
  setup do
    @tribunal_corte = tribunal_cortes(:one)
  end

  test "visiting the index" do
    visit tribunal_cortes_url
    assert_selector "h1", text: "Tribunal Cortes"
  end

  test "creating a Tribunal corte" do
    visit tribunal_cortes_url
    click_on "New Tribunal Corte"

    fill_in "Tribunal corte", with: @tribunal_corte.tribunal_corte
    click_on "Create Tribunal corte"

    assert_text "Tribunal corte was successfully created"
    click_on "Back"
  end

  test "updating a Tribunal corte" do
    visit tribunal_cortes_url
    click_on "Edit", match: :first

    fill_in "Tribunal corte", with: @tribunal_corte.tribunal_corte
    click_on "Update Tribunal corte"

    assert_text "Tribunal corte was successfully updated"
    click_on "Back"
  end

  test "destroying a Tribunal corte" do
    visit tribunal_cortes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tribunal corte was successfully destroyed"
  end
end
