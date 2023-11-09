require 'test_helper'

class OrgEmpleadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org_empleado = org_empleados(:one)
  end

  test "should get index" do
    get org_empleados_url
    assert_response :success
  end

  test "should get new" do
    get new_org_empleado_url
    assert_response :success
  end

  test "should create org_empleado" do
    assert_difference('OrgEmpleado.count') do
      post org_empleados_url, params: { org_empleado: { apellido_materno: @org_empleado.apellido_materno, apellido_paterno: @org_empleado.apellido_paterno, fecha_nacimiento: @org_empleado.fecha_nacimiento, nombres: @org_empleado.nombres, org_cargo_id: @org_empleado.org_cargo_id, rut: @org_empleado.rut } }
    end

    assert_redirected_to org_empleado_url(OrgEmpleado.last)
  end

  test "should show org_empleado" do
    get org_empleado_url(@org_empleado)
    assert_response :success
  end

  test "should get edit" do
    get edit_org_empleado_url(@org_empleado)
    assert_response :success
  end

  test "should update org_empleado" do
    patch org_empleado_url(@org_empleado), params: { org_empleado: { apellido_materno: @org_empleado.apellido_materno, apellido_paterno: @org_empleado.apellido_paterno, fecha_nacimiento: @org_empleado.fecha_nacimiento, nombres: @org_empleado.nombres, org_cargo_id: @org_empleado.org_cargo_id, rut: @org_empleado.rut } }
    assert_redirected_to org_empleado_url(@org_empleado)
  end

  test "should destroy org_empleado" do
    assert_difference('OrgEmpleado.count', -1) do
      delete org_empleado_url(@org_empleado)
    end

    assert_redirected_to org_empleados_url
  end
end
