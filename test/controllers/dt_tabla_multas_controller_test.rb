require 'test_helper'

class DtTablaMultasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_tabla_multa = dt_tabla_multas(:one)
  end

  test "should get index" do
    get dt_tabla_multas_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_tabla_multa_url
    assert_response :success
  end

  test "should create dt_tabla_multa" do
    assert_difference('DtTablaMulta.count') do
      post dt_tabla_multas_url, params: { dt_tabla_multa: { dt_tabla_multa: @dt_tabla_multa.dt_tabla_multa } }
    end

    assert_redirected_to dt_tabla_multa_url(DtTablaMulta.last)
  end

  test "should show dt_tabla_multa" do
    get dt_tabla_multa_url(@dt_tabla_multa)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_tabla_multa_url(@dt_tabla_multa)
    assert_response :success
  end

  test "should update dt_tabla_multa" do
    patch dt_tabla_multa_url(@dt_tabla_multa), params: { dt_tabla_multa: { dt_tabla_multa: @dt_tabla_multa.dt_tabla_multa } }
    assert_redirected_to dt_tabla_multa_url(@dt_tabla_multa)
  end

  test "should destroy dt_tabla_multa" do
    assert_difference('DtTablaMulta.count', -1) do
      delete dt_tabla_multa_url(@dt_tabla_multa)
    end

    assert_redirected_to dt_tabla_multas_url
  end
end
