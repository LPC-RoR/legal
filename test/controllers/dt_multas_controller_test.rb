require 'test_helper'

class DtMultasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dt_multa = dt_multas(:one)
  end

  test "should get index" do
    get dt_multas_url
    assert_response :success
  end

  test "should get new" do
    get new_dt_multa_url
    assert_response :success
  end

  test "should create dt_multa" do
    assert_difference('DtMulta.count') do
      post dt_multas_url, params: { dt_multa: { grave: @dt_multa.grave, gravisima: @dt_multa.gravisima, leve: @dt_multa.leve, orden: @dt_multa.orden, tamanio: @dt_multa.tamanio } }
    end

    assert_redirected_to dt_multa_url(DtMulta.last)
  end

  test "should show dt_multa" do
    get dt_multa_url(@dt_multa)
    assert_response :success
  end

  test "should get edit" do
    get edit_dt_multa_url(@dt_multa)
    assert_response :success
  end

  test "should update dt_multa" do
    patch dt_multa_url(@dt_multa), params: { dt_multa: { grave: @dt_multa.grave, gravisima: @dt_multa.gravisima, leve: @dt_multa.leve, orden: @dt_multa.orden, tamanio: @dt_multa.tamanio } }
    assert_redirected_to dt_multa_url(@dt_multa)
  end

  test "should destroy dt_multa" do
    assert_difference('DtMulta.count', -1) do
      delete dt_multa_url(@dt_multa)
    end

    assert_redirected_to dt_multas_url
  end
end
