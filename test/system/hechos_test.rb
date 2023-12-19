require "application_system_test_case"

class HechosTest < ApplicationSystemTestCase
  setup do
    @hecho = hechos(:one)
  end

  test "visiting the index" do
    visit hechos_url
    assert_selector "h1", text: "Hechos"
  end

  test "creating a Hecho" do
    visit hechos_url
    click_on "New Hecho"

    fill_in "Archivo", with: @hecho.archivo
    fill_in "Cita", with: @hecho.cita
    fill_in "Hecho", with: @hecho.hecho
    fill_in "Orden", with: @hecho.orden
    fill_in "Tema", with: @hecho.tema_id
    click_on "Create Hecho"

    assert_text "Hecho was successfully created"
    click_on "Back"
  end

  test "updating a Hecho" do
    visit hechos_url
    click_on "Edit", match: :first

    fill_in "Archivo", with: @hecho.archivo
    fill_in "Cita", with: @hecho.cita
    fill_in "Hecho", with: @hecho.hecho
    fill_in "Orden", with: @hecho.orden
    fill_in "Tema", with: @hecho.tema_id
    click_on "Update Hecho"

    assert_text "Hecho was successfully updated"
    click_on "Back"
  end

  test "destroying a Hecho" do
    visit hechos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hecho was successfully destroyed"
  end
end
