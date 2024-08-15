require "application_system_test_case"

class LglNEmpleadosTest < ApplicationSystemTestCase
  setup do
    @lgl_n_empleado = lgl_n_empleados(:one)
  end

  test "visiting the index" do
    visit lgl_n_empleados_url
    assert_selector "h1", text: "Lgl n empleados"
  end

  test "should create lgl n empleado" do
    visit lgl_n_empleados_url
    click_on "New lgl n empleado"

    fill_in "Lgl n empleados", with: @lgl_n_empleado.lgl_n_empleados
    fill_in "N max", with: @lgl_n_empleado.n_max
    fill_in "N min", with: @lgl_n_empleado.n_min
    click_on "Create Lgl n empleado"

    assert_text "Lgl n empleado was successfully created"
    click_on "Back"
  end

  test "should update Lgl n empleado" do
    visit lgl_n_empleado_url(@lgl_n_empleado)
    click_on "Edit this lgl n empleado", match: :first

    fill_in "Lgl n empleados", with: @lgl_n_empleado.lgl_n_empleados
    fill_in "N max", with: @lgl_n_empleado.n_max
    fill_in "N min", with: @lgl_n_empleado.n_min
    click_on "Update Lgl n empleado"

    assert_text "Lgl n empleado was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl n empleado" do
    visit lgl_n_empleado_url(@lgl_n_empleado)
    click_on "Destroy this lgl n empleado", match: :first

    assert_text "Lgl n empleado was successfully destroyed"
  end
end
