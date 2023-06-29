require 'test_helper'

class MDatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_dato = m_datos(:one)
  end

  test "should get index" do
    get m_datos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_dato_url
    assert_response :success
  end

  test "should create m_dato" do
    assert_difference('MDato.count') do
      post m_datos_url, params: { m_dato: { formula: @m_dato.formula, m_dato: @m_dato.m_dato, m_formato_id: @m_dato.m_formato_id, split_tag: @m_dato.split_tag, tipo: @m_dato.tipo } }
    end

    assert_redirected_to m_dato_url(MDato.last)
  end

  test "should show m_dato" do
    get m_dato_url(@m_dato)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_dato_url(@m_dato)
    assert_response :success
  end

  test "should update m_dato" do
    patch m_dato_url(@m_dato), params: { m_dato: { formula: @m_dato.formula, m_dato: @m_dato.m_dato, m_formato_id: @m_dato.m_formato_id, split_tag: @m_dato.split_tag, tipo: @m_dato.tipo } }
    assert_redirected_to m_dato_url(@m_dato)
  end

  test "should destroy m_dato" do
    assert_difference('MDato.count', -1) do
      delete m_dato_url(@m_dato)
    end

    assert_redirected_to m_datos_url
  end
end
