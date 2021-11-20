require 'test_helper'

class TarFacturacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_facturacion = tar_facturaciones(:one)
  end

  test "should get index" do
    get tar_facturaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_facturacion_url
    assert_response :success
  end

  test "should create tar_facturacion" do
    assert_difference('TarFacturacion.count') do
      post tar_facturaciones_url, params: { tar_facturacion: { estado: @tar_facturacion.estado, facturable: @tar_facturacion.facturable, monto: @tar_facturacion.monto, owner_class: @tar_facturacion.owner_class, owner_id: @tar_facturacion.owner_id } }
    end

    assert_redirected_to tar_facturacion_url(TarFacturacion.last)
  end

  test "should show tar_facturacion" do
    get tar_facturacion_url(@tar_facturacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_facturacion_url(@tar_facturacion)
    assert_response :success
  end

  test "should update tar_facturacion" do
    patch tar_facturacion_url(@tar_facturacion), params: { tar_facturacion: { estado: @tar_facturacion.estado, facturable: @tar_facturacion.facturable, monto: @tar_facturacion.monto, owner_class: @tar_facturacion.owner_class, owner_id: @tar_facturacion.owner_id } }
    assert_redirected_to tar_facturacion_url(@tar_facturacion)
  end

  test "should destroy tar_facturacion" do
    assert_difference('TarFacturacion.count', -1) do
      delete tar_facturacion_url(@tar_facturacion)
    end

    assert_redirected_to tar_facturaciones_url
  end
end
