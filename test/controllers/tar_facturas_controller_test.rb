require 'test_helper'

class TarFacturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_factura = tar_facturas(:one)
  end

  test "should get index" do
    get tar_facturas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_factura_url
    assert_response :success
  end

  test "should create tar_factura" do
    assert_difference('TarFactura.count') do
      post tar_facturas_url, params: { tar_factura: { documento: @tar_factura.documento, estado: @tar_factura.estado, owner_class: @tar_factura.owner_class, owner_id: @tar_factura.owner_id } }
    end

    assert_redirected_to tar_factura_url(TarFactura.last)
  end

  test "should show tar_factura" do
    get tar_factura_url(@tar_factura)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_factura_url(@tar_factura)
    assert_response :success
  end

  test "should update tar_factura" do
    patch tar_factura_url(@tar_factura), params: { tar_factura: { documento: @tar_factura.documento, estado: @tar_factura.estado, owner_class: @tar_factura.owner_class, owner_id: @tar_factura.owner_id } }
    assert_redirected_to tar_factura_url(@tar_factura)
  end

  test "should destroy tar_factura" do
    assert_difference('TarFactura.count', -1) do
      delete tar_factura_url(@tar_factura)
    end

    assert_redirected_to tar_facturas_url
  end
end
