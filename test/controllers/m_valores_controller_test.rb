require 'test_helper'

class MValoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_valor = m_valores(:one)
  end

  test "should get index" do
    get m_valores_url
    assert_response :success
  end

  test "should get new" do
    get new_m_valor_url
    assert_response :success
  end

  test "should create m_valor" do
    assert_difference('MValor.count') do
      post m_valores_url, params: { m_valor: { m_conciliacion_id: @m_valor.m_conciliacion_id, m_valor: @m_valor.m_valor, orden: @m_valor.orden, tipo: @m_valor.tipo, valor: @m_valor.valor } }
    end

    assert_redirected_to m_valor_url(MValor.last)
  end

  test "should show m_valor" do
    get m_valor_url(@m_valor)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_valor_url(@m_valor)
    assert_response :success
  end

  test "should update m_valor" do
    patch m_valor_url(@m_valor), params: { m_valor: { m_conciliacion_id: @m_valor.m_conciliacion_id, m_valor: @m_valor.m_valor, orden: @m_valor.orden, tipo: @m_valor.tipo, valor: @m_valor.valor } }
    assert_redirected_to m_valor_url(@m_valor)
  end

  test "should destroy m_valor" do
    assert_difference('MValor.count', -1) do
      delete m_valor_url(@m_valor)
    end

    assert_redirected_to m_valores_url
  end
end
