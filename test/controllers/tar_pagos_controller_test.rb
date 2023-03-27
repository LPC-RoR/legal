require 'test_helper'

class TarPagosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_pago = tar_pagos(:one)
  end

  test "should get index" do
    get tar_pagos_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_pago_url
    assert_response :success
  end

  test "should create tar_pago" do
    assert_difference('TarPago.count') do
      post tar_pagos_url, params: { tar_pago: { estado: @tar_pago.estado, moneda: @tar_pago.moneda, tar_pago: @tar_pago.tar_pago, tar_tarifa_id: @tar_pago.tar_tarifa_id, valor: @tar_pago.valor } }
    end

    assert_redirected_to tar_pago_url(TarPago.last)
  end

  test "should show tar_pago" do
    get tar_pago_url(@tar_pago)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_pago_url(@tar_pago)
    assert_response :success
  end

  test "should update tar_pago" do
    patch tar_pago_url(@tar_pago), params: { tar_pago: { estado: @tar_pago.estado, moneda: @tar_pago.moneda, tar_pago: @tar_pago.tar_pago, tar_tarifa_id: @tar_pago.tar_tarifa_id, valor: @tar_pago.valor } }
    assert_redirected_to tar_pago_url(@tar_pago)
  end

  test "should destroy tar_pago" do
    assert_difference('TarPago.count', -1) do
      delete tar_pago_url(@tar_pago)
    end

    assert_redirected_to tar_pagos_url
  end
end
