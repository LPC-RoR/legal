require "application_system_test_case"

class LglCitasTest < ApplicationSystemTestCase
  setup do
    @lgl_cita = lgl_citas(:one)
  end

  test "visiting the index" do
    visit lgl_citas_url
    assert_selector "h1", text: "Lgl citas"
  end

  test "should create lgl cita" do
    visit lgl_citas_url
    click_on "New lgl cita"

    fill_in "Codigo", with: @lgl_cita.codigo
    fill_in "Lgl cita", with: @lgl_cita.lgl_cita
    fill_in "Lgl parrafo", with: @lgl_cita.lgl_parrafo_id
    fill_in "Orden", with: @lgl_cita.orden
    fill_in "Referencia", with: @lgl_cita.referencia
    click_on "Create Lgl cita"

    assert_text "Lgl cita was successfully created"
    click_on "Back"
  end

  test "should update Lgl cita" do
    visit lgl_cita_url(@lgl_cita)
    click_on "Edit this lgl cita", match: :first

    fill_in "Codigo", with: @lgl_cita.codigo
    fill_in "Lgl cita", with: @lgl_cita.lgl_cita
    fill_in "Lgl parrafo", with: @lgl_cita.lgl_parrafo_id
    fill_in "Orden", with: @lgl_cita.orden
    fill_in "Referencia", with: @lgl_cita.referencia
    click_on "Update Lgl cita"

    assert_text "Lgl cita was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl cita" do
    visit lgl_cita_url(@lgl_cita)
    click_on "Destroy this lgl cita", match: :first

    assert_text "Lgl cita was successfully destroyed"
  end
end
