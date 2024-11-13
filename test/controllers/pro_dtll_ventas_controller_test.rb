require "test_helper"

class ProDtllVentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pro_dtll_venta = pro_dtll_ventas(:one)
  end

  test "should get index" do
    get pro_dtll_ventas_url
    assert_response :success
  end

  test "should get new" do
    get new_pro_dtll_venta_url
    assert_response :success
  end

  test "should create pro_dtll_venta" do
    assert_difference("ProDtllVenta.count") do
      post pro_dtll_ventas_url, params: { pro_dtll_venta: { fecha_activacion: @pro_dtll_venta.fecha_activacion, ownr_id: @pro_dtll_venta.ownr_id, ownr_type: @pro_dtll_venta.ownr_type, producto_id: @pro_dtll_venta.producto_id } }
    end

    assert_redirected_to pro_dtll_venta_url(ProDtllVenta.last)
  end

  test "should show pro_dtll_venta" do
    get pro_dtll_venta_url(@pro_dtll_venta)
    assert_response :success
  end

  test "should get edit" do
    get edit_pro_dtll_venta_url(@pro_dtll_venta)
    assert_response :success
  end

  test "should update pro_dtll_venta" do
    patch pro_dtll_venta_url(@pro_dtll_venta), params: { pro_dtll_venta: { fecha_activacion: @pro_dtll_venta.fecha_activacion, ownr_id: @pro_dtll_venta.ownr_id, ownr_type: @pro_dtll_venta.ownr_type, producto_id: @pro_dtll_venta.producto_id } }
    assert_redirected_to pro_dtll_venta_url(@pro_dtll_venta)
  end

  test "should destroy pro_dtll_venta" do
    assert_difference("ProDtllVenta.count", -1) do
      delete pro_dtll_venta_url(@pro_dtll_venta)
    end

    assert_redirected_to pro_dtll_ventas_url
  end
end
