require "application_system_test_case"

class TrabajadoresTest < ApplicationSystemTestCase
  setup do
    @trabajador = trabajadores(:one)
  end

  test "visiting the index" do
    visit trabajadores_url
    assert_selector "h1", text: "Trabajadores"
  end

  test "should create trabajador" do
    visit trabajadores_url
    click_on "New trabajador"

    fill_in "Nombre", with: @trabajador.nombre
    fill_in "Rut", with: @trabajador.rut
    click_on "Create Trabajador"

    assert_text "Trabajador was successfully created"
    click_on "Back"
  end

  test "should update Trabajador" do
    visit trabajador_url(@trabajador)
    click_on "Edit this trabajador", match: :first

    fill_in "Nombre", with: @trabajador.nombre
    fill_in "Rut", with: @trabajador.rut
    click_on "Update Trabajador"

    assert_text "Trabajador was successfully updated"
    click_on "Back"
  end

  test "should destroy Trabajador" do
    visit trabajador_url(@trabajador)
    click_on "Destroy this trabajador", match: :first

    assert_text "Trabajador was successfully destroyed"
  end
end
