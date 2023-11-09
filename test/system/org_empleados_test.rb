require "application_system_test_case"

class OrgEmpleadosTest < ApplicationSystemTestCase
  setup do
    @org_empleado = org_empleados(:one)
  end

  test "visiting the index" do
    visit org_empleados_url
    assert_selector "h1", text: "Org Empleados"
  end

  test "creating a Org empleado" do
    visit org_empleados_url
    click_on "New Org Empleado"

    fill_in "Apellido materno", with: @org_empleado.apellido_materno
    fill_in "Apellido paterno", with: @org_empleado.apellido_paterno
    fill_in "Fecha nacimiento", with: @org_empleado.fecha_nacimiento
    fill_in "Nombres", with: @org_empleado.nombres
    fill_in "Org cargo", with: @org_empleado.org_cargo_id
    fill_in "Rut", with: @org_empleado.rut
    click_on "Create Org empleado"

    assert_text "Org empleado was successfully created"
    click_on "Back"
  end

  test "updating a Org empleado" do
    visit org_empleados_url
    click_on "Edit", match: :first

    fill_in "Apellido materno", with: @org_empleado.apellido_materno
    fill_in "Apellido paterno", with: @org_empleado.apellido_paterno
    fill_in "Fecha nacimiento", with: @org_empleado.fecha_nacimiento
    fill_in "Nombres", with: @org_empleado.nombres
    fill_in "Org cargo", with: @org_empleado.org_cargo_id
    fill_in "Rut", with: @org_empleado.rut
    click_on "Update Org empleado"

    assert_text "Org empleado was successfully updated"
    click_on "Back"
  end

  test "destroying a Org empleado" do
    visit org_empleados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org empleado was successfully destroyed"
  end
end
