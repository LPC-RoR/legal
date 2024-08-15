require "test_helper"

class LglNEmpleadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_n_empleado = lgl_n_empleados(:one)
  end

  test "should get index" do
    get lgl_n_empleados_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_n_empleado_url
    assert_response :success
  end

  test "should create lgl_n_empleado" do
    assert_difference("LglNEmpleado.count") do
      post lgl_n_empleados_url, params: { lgl_n_empleado: { lgl_n_empleados: @lgl_n_empleado.lgl_n_empleados, n_max: @lgl_n_empleado.n_max, n_min: @lgl_n_empleado.n_min } }
    end

    assert_redirected_to lgl_n_empleado_url(LglNEmpleado.last)
  end

  test "should show lgl_n_empleado" do
    get lgl_n_empleado_url(@lgl_n_empleado)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_n_empleado_url(@lgl_n_empleado)
    assert_response :success
  end

  test "should update lgl_n_empleado" do
    patch lgl_n_empleado_url(@lgl_n_empleado), params: { lgl_n_empleado: { lgl_n_empleados: @lgl_n_empleado.lgl_n_empleados, n_max: @lgl_n_empleado.n_max, n_min: @lgl_n_empleado.n_min } }
    assert_redirected_to lgl_n_empleado_url(@lgl_n_empleado)
  end

  test "should destroy lgl_n_empleado" do
    assert_difference("LglNEmpleado.count", -1) do
      delete lgl_n_empleado_url(@lgl_n_empleado)
    end

    assert_redirected_to lgl_n_empleados_url
  end
end
