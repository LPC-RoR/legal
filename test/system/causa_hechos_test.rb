require "application_system_test_case"

class CausaHechosTest < ApplicationSystemTestCase
  setup do
    @causa_hecho = causa_hechos(:one)
  end

  test "visiting the index" do
    visit causa_hechos_url
    assert_selector "h1", text: "Causa Hechos"
  end

  test "creating a Causa hecho" do
    visit causa_hechos_url
    click_on "New Causa Hecho"

    fill_in "Causa", with: @causa_hecho.causa_id
    fill_in "Hecho", with: @causa_hecho.hecho_id
    fill_in "Orden", with: @causa_hecho.orden
    fill_in "St contestación", with: @causa_hecho.st_contestación
    fill_in "St juicio", with: @causa_hecho.st_juicio
    fill_in "St preparatoria", with: @causa_hecho.st_preparatoria
    click_on "Create Causa hecho"

    assert_text "Causa hecho was successfully created"
    click_on "Back"
  end

  test "updating a Causa hecho" do
    visit causa_hechos_url
    click_on "Edit", match: :first

    fill_in "Causa", with: @causa_hecho.causa_id
    fill_in "Hecho", with: @causa_hecho.hecho_id
    fill_in "Orden", with: @causa_hecho.orden
    fill_in "St contestación", with: @causa_hecho.st_contestación
    fill_in "St juicio", with: @causa_hecho.st_juicio
    fill_in "St preparatoria", with: @causa_hecho.st_preparatoria
    click_on "Update Causa hecho"

    assert_text "Causa hecho was successfully updated"
    click_on "Back"
  end

  test "destroying a Causa hecho" do
    visit causa_hechos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Causa hecho was successfully destroyed"
  end
end
