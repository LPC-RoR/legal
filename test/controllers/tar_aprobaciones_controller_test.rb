require 'test_helper'

class TarAprobacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_aprobacion = tar_aprobaciones(:one)
  end

  test "should get index" do
    get tar_aprobaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_aprobacion_url
    assert_response :success
  end

  test "should create tar_aprobacion" do
    assert_difference('TarAprobacion.count') do
      post tar_aprobaciones_url, params: { tar_aprobacion: { cliente_id: @tar_aprobacion.cliente_id, fecha: @tar_aprobacion.fecha } }
    end

    assert_redirected_to tar_aprobacion_url(TarAprobacion.last)
  end

  test "should show tar_aprobacion" do
    get tar_aprobacion_url(@tar_aprobacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_aprobacion_url(@tar_aprobacion)
    assert_response :success
  end

  test "should update tar_aprobacion" do
    patch tar_aprobacion_url(@tar_aprobacion), params: { tar_aprobacion: { cliente_id: @tar_aprobacion.cliente_id, fecha: @tar_aprobacion.fecha } }
    assert_redirected_to tar_aprobacion_url(@tar_aprobacion)
  end

  test "should destroy tar_aprobacion" do
    assert_difference('TarAprobacion.count', -1) do
      delete tar_aprobacion_url(@tar_aprobacion)
    end

    assert_redirected_to tar_aprobaciones_url
  end
end
