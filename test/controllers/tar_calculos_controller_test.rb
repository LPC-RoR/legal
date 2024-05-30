require 'test_helper'

class TarCalculosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_calculo = tar_calculos(:one)
  end

  test "should get index" do
    get tar_calculos_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_calculo_url
    assert_response :success
  end

  test "should create tar_calculo" do
    assert_difference('TarCalculo.count') do
      post tar_calculos_url, params: { tar_calculo: { clnt_id: @tar_calculo.clnt_id, cuantia: @tar_calculo.cuantia, glosa: @tar_calculo.glosa, moneda: @tar_calculo.moneda, monto: @tar_calculo.monto, ownr_clss: @tar_calculo.ownr_clss, ownr_id: @tar_calculo.ownr_id, tar_pago_id: @tar_calculo.tar_pago_id } }
    end

    assert_redirected_to tar_calculo_url(TarCalculo.last)
  end

  test "should show tar_calculo" do
    get tar_calculo_url(@tar_calculo)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_calculo_url(@tar_calculo)
    assert_response :success
  end

  test "should update tar_calculo" do
    patch tar_calculo_url(@tar_calculo), params: { tar_calculo: { clnt_id: @tar_calculo.clnt_id, cuantia: @tar_calculo.cuantia, glosa: @tar_calculo.glosa, moneda: @tar_calculo.moneda, monto: @tar_calculo.monto, ownr_clss: @tar_calculo.ownr_clss, ownr_id: @tar_calculo.ownr_id, tar_pago_id: @tar_calculo.tar_pago_id } }
    assert_redirected_to tar_calculo_url(@tar_calculo)
  end

  test "should destroy tar_calculo" do
    assert_difference('TarCalculo.count', -1) do
      delete tar_calculo_url(@tar_calculo)
    end

    assert_redirected_to tar_calculos_url
  end
end
