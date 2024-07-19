require "application_system_test_case"

class LglPuntosTest < ApplicationSystemTestCase
  setup do
    @lgl_punto = lgl_puntos(:one)
  end

  test "visiting the index" do
    visit lgl_puntos_url
    assert_selector "h1", text: "Lgl puntos"
  end

  test "should create lgl punto" do
    visit lgl_puntos_url
    click_on "New lgl punto"

    fill_in "Cita", with: @lgl_punto.cita
    fill_in "Lgl parrafo", with: @lgl_punto.lgl_parrafo_id
    fill_in "Lgl punto", with: @lgl_punto.lgl_punto
    fill_in "Orden", with: @lgl_punto.orden
    click_on "Create Lgl punto"

    assert_text "Lgl punto was successfully created"
    click_on "Back"
  end

  test "should update Lgl punto" do
    visit lgl_punto_url(@lgl_punto)
    click_on "Edit this lgl punto", match: :first

    fill_in "Cita", with: @lgl_punto.cita
    fill_in "Lgl parrafo", with: @lgl_punto.lgl_parrafo_id
    fill_in "Lgl punto", with: @lgl_punto.lgl_punto
    fill_in "Orden", with: @lgl_punto.orden
    click_on "Update Lgl punto"

    assert_text "Lgl punto was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl punto" do
    visit lgl_punto_url(@lgl_punto)
    click_on "Destroy this lgl punto", match: :first

    assert_text "Lgl punto was successfully destroyed"
  end
end
