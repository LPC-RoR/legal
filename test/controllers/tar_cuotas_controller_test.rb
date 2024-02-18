require 'test_helper'

class TarCuotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_cuota = tar_cuotas(:one)
  end

  test "should get index" do
    get tar_cuotas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_cuota_url
    assert_response :success
  end

  test "should create tar_cuota" do
    assert_difference('TarCuota.count') do
      post tar_cuotas_url, params: { tar_cuota: { moneda: @tar_cuota.moneda, monto: @tar_cuota.monto, orden: @tar_cuota.orden, porcentaje: @tar_cuota.porcentaje, tar_cuota: @tar_cuota.tar_cuota, tar_pago_id: @tar_cuota.tar_pago_id, ultima_cuota: @tar_cuota.ultima_cuota } }
    end

    assert_redirected_to tar_cuota_url(TarCuota.last)
  end

  test "should show tar_cuota" do
    get tar_cuota_url(@tar_cuota)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_cuota_url(@tar_cuota)
    assert_response :success
  end

  test "should update tar_cuota" do
    patch tar_cuota_url(@tar_cuota), params: { tar_cuota: { moneda: @tar_cuota.moneda, monto: @tar_cuota.monto, orden: @tar_cuota.orden, porcentaje: @tar_cuota.porcentaje, tar_cuota: @tar_cuota.tar_cuota, tar_pago_id: @tar_cuota.tar_pago_id, ultima_cuota: @tar_cuota.ultima_cuota } }
    assert_redirected_to tar_cuota_url(@tar_cuota)
  end

  test "should destroy tar_cuota" do
    assert_difference('TarCuota.count', -1) do
      delete tar_cuota_url(@tar_cuota)
    end

    assert_redirected_to tar_cuotas_url
  end
end
