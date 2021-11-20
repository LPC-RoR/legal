require 'test_helper'

class TarDetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_detalle = tar_detalles(:one)
  end

  test "should get index" do
    get tar_detalles_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_detalle_url
    assert_response :success
  end

  test "should create tar_detalle" do
    assert_difference('TarDetalle.count') do
      post tar_detalles_url, params: { tar_detalle: { codigo: @tar_detalle.codigo, detalle: @tar_detalle.detalle, formula: @tar_detalle.formula, orden: @tar_detalle.orden, tar_tarifa_id: @tar_detalle.tar_tarifa_id, tipo: @tar_detalle.tipo } }
    end

    assert_redirected_to tar_detalle_url(TarDetalle.last)
  end

  test "should show tar_detalle" do
    get tar_detalle_url(@tar_detalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_detalle_url(@tar_detalle)
    assert_response :success
  end

  test "should update tar_detalle" do
    patch tar_detalle_url(@tar_detalle), params: { tar_detalle: { codigo: @tar_detalle.codigo, detalle: @tar_detalle.detalle, formula: @tar_detalle.formula, orden: @tar_detalle.orden, tar_tarifa_id: @tar_detalle.tar_tarifa_id, tipo: @tar_detalle.tipo } }
    assert_redirected_to tar_detalle_url(@tar_detalle)
  end

  test "should destroy tar_detalle" do
    assert_difference('TarDetalle.count', -1) do
      delete tar_detalle_url(@tar_detalle)
    end

    assert_redirected_to tar_detalles_url
  end
end
