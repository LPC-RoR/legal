require 'test_helper'

class CalFeriadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cal_feriado = cal_feriados(:one)
  end

  test "should get index" do
    get cal_feriados_url
    assert_response :success
  end

  test "should get new" do
    get new_cal_feriado_url
    assert_response :success
  end

  test "should create cal_feriado" do
    assert_difference('CalFeriado.count') do
      post cal_feriados_url, params: { cal_feriado: { cal_annio_id: @cal_feriado.cal_annio_id, cal_fecha: @cal_feriado.cal_fecha, descripcion: @cal_feriado.descripcion } }
    end

    assert_redirected_to cal_feriado_url(CalFeriado.last)
  end

  test "should show cal_feriado" do
    get cal_feriado_url(@cal_feriado)
    assert_response :success
  end

  test "should get edit" do
    get edit_cal_feriado_url(@cal_feriado)
    assert_response :success
  end

  test "should update cal_feriado" do
    patch cal_feriado_url(@cal_feriado), params: { cal_feriado: { cal_annio_id: @cal_feriado.cal_annio_id, cal_fecha: @cal_feriado.cal_fecha, descripcion: @cal_feriado.descripcion } }
    assert_redirected_to cal_feriado_url(@cal_feriado)
  end

  test "should destroy cal_feriado" do
    assert_difference('CalFeriado.count', -1) do
      delete cal_feriado_url(@cal_feriado)
    end

    assert_redirected_to cal_feriados_url
  end
end
