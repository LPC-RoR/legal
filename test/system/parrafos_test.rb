require "application_system_test_case"

class ParrafosTest < ApplicationSystemTestCase
  setup do
    @parrafo = parrafos(:one)
  end

  test "visiting the index" do
    visit parrafos_url
    assert_selector "h1", text: "Parrafos"
  end

  test "should create parrafo" do
    visit parrafos_url
    click_on "New parrafo"

    fill_in "Causa", with: @parrafo.causa_id
    fill_in "Orden", with: @parrafo.orden
    fill_in "Seccion", with: @parrafo.seccion_id
    fill_in "Texto", with: @parrafo.texto
    click_on "Create Parrafo"

    assert_text "Parrafo was successfully created"
    click_on "Back"
  end

  test "should update Parrafo" do
    visit parrafo_url(@parrafo)
    click_on "Edit this parrafo", match: :first

    fill_in "Causa", with: @parrafo.causa_id
    fill_in "Orden", with: @parrafo.orden
    fill_in "Seccion", with: @parrafo.seccion_id
    fill_in "Texto", with: @parrafo.texto
    click_on "Update Parrafo"

    assert_text "Parrafo was successfully updated"
    click_on "Back"
  end

  test "should destroy Parrafo" do
    visit parrafo_url(@parrafo)
    click_on "Destroy this parrafo", match: :first

    assert_text "Parrafo was successfully destroyed"
  end
end
