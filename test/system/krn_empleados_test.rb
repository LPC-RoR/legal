require "application_system_test_case"

class KrnEmpleadosTest < ApplicationSystemTestCase
  setup do
    @krn_empleado = krn_empleados(:one)
  end

  test "visiting the index" do
    visit krn_empleados_url
    assert_selector "h1", text: "Krn empleados"
  end

  test "should create krn empleado" do
    visit krn_empleados_url
    click_on "New krn empleado"

    fill_in "Cliente", with: @krn_empleado.cliente_id
    fill_in "Empresa", with: @krn_empleado.empresa_id
    fill_in "Nombre", with: @krn_empleado.nombre
    fill_in "Rut", with: @krn_empleado.rut
    click_on "Create Krn empleado"

    assert_text "Krn empleado was successfully created"
    click_on "Back"
  end

  test "should update Krn empleado" do
    visit krn_empleado_url(@krn_empleado)
    click_on "Edit this krn empleado", match: :first

    fill_in "Cliente", with: @krn_empleado.cliente_id
    fill_in "Empresa", with: @krn_empleado.empresa_id
    fill_in "Nombre", with: @krn_empleado.nombre
    fill_in "Rut", with: @krn_empleado.rut
    click_on "Update Krn empleado"

    assert_text "Krn empleado was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn empleado" do
    visit krn_empleado_url(@krn_empleado)
    click_on "Destroy this krn empleado", match: :first

    assert_text "Krn empleado was successfully destroyed"
  end
end
