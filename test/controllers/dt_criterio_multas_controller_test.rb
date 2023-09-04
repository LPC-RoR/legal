require 'test_helper'

class DtCriterioMultasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_criterio_multa = dt_criterio_multas(:one)
  end

  test "should get index" do
    get dt_criterio_multas_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_criterio_multa_url
    assert_response :success
  end

  test "should create dt_criterio_multa" do
    assert_difference('DtCriterioMulta.count') do
      post dt_criterio_multas_url, params: { dt_criterio_multa: { dt_criterio_multa: @dt_criterio_multa.dt_criterio_multa, dt_tabla_multa_id: @dt_criterio_multa.dt_tabla_multa_id, monto: @dt_criterio_multa.monto, orden: @dt_criterio_multa.orden, unidad: @dt_criterio_multa.unidad } }
    end

    assert_redirected_to dt_criterio_multa_url(DtCriterioMulta.last)
  end

  test "should show dt_criterio_multa" do
    get dt_criterio_multa_url(@dt_criterio_multa)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_criterio_multa_url(@dt_criterio_multa)
    assert_response :success
  end

  test "should update dt_criterio_multa" do
    patch dt_criterio_multa_url(@dt_criterio_multa), params: { dt_criterio_multa: { dt_criterio_multa: @dt_criterio_multa.dt_criterio_multa, dt_tabla_multa_id: @dt_criterio_multa.dt_tabla_multa_id, monto: @dt_criterio_multa.monto, orden: @dt_criterio_multa.orden, unidad: @dt_criterio_multa.unidad } }
    assert_redirected_to dt_criterio_multa_url(@dt_criterio_multa)
  end

  test "should destroy dt_criterio_multa" do
    assert_difference('DtCriterioMulta.count', -1) do
      delete dt_criterio_multa_url(@dt_criterio_multa)
    end

    assert_redirected_to dt_criterio_multas_url
  end
end
