require "application_system_test_case"

class LglParrafosTest < ApplicationSystemTestCase
  setup do
    @lgl_parrafo = lgl_parrafos(:one)
  end

  test "visiting the index" do
    visit lgl_parrafos_url
    assert_selector "h1", text: "Lgl parrafos"
  end

  test "should create lgl parrafo" do
    visit lgl_parrafos_url
    click_on "New lgl parrafo"

    fill_in "Lgl documento", with: @lgl_parrafo.lgl_documento_id
    fill_in "Lgl parrafo", with: @lgl_parrafo.lgl_parrafo
    fill_in "Orden", with: @lgl_parrafo.orden
    fill_in "Tipo", with: @lgl_parrafo.tipo
    click_on "Create Lgl parrafo"

    assert_text "Lgl parrafo was successfully created"
    click_on "Back"
  end

  test "should update Lgl parrafo" do
    visit lgl_parrafo_url(@lgl_parrafo)
    click_on "Edit this lgl parrafo", match: :first

    fill_in "Lgl documento", with: @lgl_parrafo.lgl_documento_id
    fill_in "Lgl parrafo", with: @lgl_parrafo.lgl_parrafo
    fill_in "Orden", with: @lgl_parrafo.orden
    fill_in "Tipo", with: @lgl_parrafo.tipo
    click_on "Update Lgl parrafo"

    assert_text "Lgl parrafo was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl parrafo" do
    visit lgl_parrafo_url(@lgl_parrafo)
    click_on "Destroy this lgl parrafo", match: :first

    assert_text "Lgl parrafo was successfully destroyed"
  end
end
