require "test_helper"

class MontoConciliacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @monto_conciliacion = monto_conciliaciones(:one)
  end

  test "should get index" do
    get monto_conciliaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_monto_conciliacion_url
    assert_response :success
  end

  test "should create monto_conciliacion" do
    assert_difference("MontoConciliacion.count") do
      post monto_conciliaciones_url, params: { monto_conciliacion: { causa_id: @monto_conciliacion.causa_id, fecha: @monto_conciliacion.fecha, monto: @monto_conciliacion.monto, tipo: @monto_conciliacion.tipo } }
    end

    assert_redirected_to monto_conciliacion_url(MontoConciliacion.last)
  end

  test "should show monto_conciliacion" do
    get monto_conciliacion_url(@monto_conciliacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_monto_conciliacion_url(@monto_conciliacion)
    assert_response :success
  end

  test "should update monto_conciliacion" do
    patch monto_conciliacion_url(@monto_conciliacion), params: { monto_conciliacion: { causa_id: @monto_conciliacion.causa_id, fecha: @monto_conciliacion.fecha, monto: @monto_conciliacion.monto, tipo: @monto_conciliacion.tipo } }
    assert_redirected_to monto_conciliacion_url(@monto_conciliacion)
  end

  test "should destroy monto_conciliacion" do
    assert_difference("MontoConciliacion.count", -1) do
      delete monto_conciliacion_url(@monto_conciliacion)
    end

    assert_redirected_to monto_conciliaciones_url
  end
end
