require "test_helper"

class TarFechaCalculosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_fecha_calculo = tar_fecha_calculos(:one)
  end

  test "should get index" do
    get tar_fecha_calculos_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_fecha_calculo_url
    assert_response :success
  end

  test "should create tar_fecha_calculo" do
    assert_difference("TarFechaCalculo.count") do
      post tar_fecha_calculos_url, params: { tar_fecha_calculo: { codigo_formula: @tar_fecha_calculo.codigo_formula, fecha: @tar_fecha_calculo.fecha, ownr_id: @tar_fecha_calculo.ownr_id, ownr_type: @tar_fecha_calculo.ownr_type } }
    end

    assert_redirected_to tar_fecha_calculo_url(TarFechaCalculo.last)
  end

  test "should show tar_fecha_calculo" do
    get tar_fecha_calculo_url(@tar_fecha_calculo)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_fecha_calculo_url(@tar_fecha_calculo)
    assert_response :success
  end

  test "should update tar_fecha_calculo" do
    patch tar_fecha_calculo_url(@tar_fecha_calculo), params: { tar_fecha_calculo: { codigo_formula: @tar_fecha_calculo.codigo_formula, fecha: @tar_fecha_calculo.fecha, ownr_id: @tar_fecha_calculo.ownr_id, ownr_type: @tar_fecha_calculo.ownr_type } }
    assert_redirected_to tar_fecha_calculo_url(@tar_fecha_calculo)
  end

  test "should destroy tar_fecha_calculo" do
    assert_difference("TarFechaCalculo.count", -1) do
      delete tar_fecha_calculo_url(@tar_fecha_calculo)
    end

    assert_redirected_to tar_fecha_calculos_url
  end
end
