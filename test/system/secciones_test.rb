require "application_system_test_case"

class SeccionesTest < ApplicationSystemTestCase
  setup do
    @seccion = secciones(:one)
  end

  test "visiting the index" do
    visit secciones_url
    assert_selector "h1", text: "Secciones"
  end

  test "should create seccion" do
    visit secciones_url
    click_on "New seccion"

    fill_in "Causa", with: @seccion.causa_id
    fill_in "Orden", with: @seccion.orden
    fill_in "Seccion", with: @seccion.seccion
    fill_in "Texto", with: @seccion.texto
    click_on "Create Seccion"

    assert_text "Seccion was successfully created"
    click_on "Back"
  end

  test "should update Seccion" do
    visit seccion_url(@seccion)
    click_on "Edit this seccion", match: :first

    fill_in "Causa", with: @seccion.causa_id
    fill_in "Orden", with: @seccion.orden
    fill_in "Seccion", with: @seccion.seccion
    fill_in "Texto", with: @seccion.texto
    click_on "Update Seccion"

    assert_text "Seccion was successfully updated"
    click_on "Back"
  end

  test "should destroy Seccion" do
    visit seccion_url(@seccion)
    click_on "Destroy this seccion", match: :first

    assert_text "Seccion was successfully destroyed"
  end
end
