require 'test_helper'

class TarUfFacturacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_uf_facturacion = tar_uf_facturaciones(:one)
  end

  test "should get index" do
    get tar_uf_facturaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_uf_facturacion_url
    assert_response :success
  end

  test "should create tar_uf_facturacion" do
    assert_difference('TarUfFacturacion.count') do
      post tar_uf_facturaciones_url, params: { tar_uf_facturacion: { fecha_uf: @tar_uf_facturacion.fecha_uf, owner_class: @tar_uf_facturacion.owner_class, owner_id: @tar_uf_facturacion.owner_id, pago: @tar_uf_facturacion.pago } }
    end

    assert_redirected_to tar_uf_facturacion_url(TarUfFacturacion.last)
  end

  test "should show tar_uf_facturacion" do
    get tar_uf_facturacion_url(@tar_uf_facturacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_uf_facturacion_url(@tar_uf_facturacion)
    assert_response :success
  end

  test "should update tar_uf_facturacion" do
    patch tar_uf_facturacion_url(@tar_uf_facturacion), params: { tar_uf_facturacion: { fecha_uf: @tar_uf_facturacion.fecha_uf, owner_class: @tar_uf_facturacion.owner_class, owner_id: @tar_uf_facturacion.owner_id, pago: @tar_uf_facturacion.pago } }
    assert_redirected_to tar_uf_facturacion_url(@tar_uf_facturacion)
  end

  test "should destroy tar_uf_facturacion" do
    assert_difference('TarUfFacturacion.count', -1) do
      delete tar_uf_facturacion_url(@tar_uf_facturacion)
    end

    assert_redirected_to tar_uf_facturaciones_url
  end
end
