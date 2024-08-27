require "test_helper"

class KrnEmpleadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_empleado = krn_empleados(:one)
  end

  test "should get index" do
    get krn_empleados_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_empleado_url
    assert_response :success
  end

  test "should create krn_empleado" do
    assert_difference("KrnEmpleado.count") do
      post krn_empleados_url, params: { krn_empleado: { cliente_id: @krn_empleado.cliente_id, empresa_id: @krn_empleado.empresa_id, nombre: @krn_empleado.nombre, rut: @krn_empleado.rut } }
    end

    assert_redirected_to krn_empleado_url(KrnEmpleado.last)
  end

  test "should show krn_empleado" do
    get krn_empleado_url(@krn_empleado)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_empleado_url(@krn_empleado)
    assert_response :success
  end

  test "should update krn_empleado" do
    patch krn_empleado_url(@krn_empleado), params: { krn_empleado: { cliente_id: @krn_empleado.cliente_id, empresa_id: @krn_empleado.empresa_id, nombre: @krn_empleado.nombre, rut: @krn_empleado.rut } }
    assert_redirected_to krn_empleado_url(@krn_empleado)
  end

  test "should destroy krn_empleado" do
    assert_difference("KrnEmpleado.count", -1) do
      delete krn_empleado_url(@krn_empleado)
    end

    assert_redirected_to krn_empleados_url
  end
end
