require 'test_helper'

class MElementosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_elemento = m_elementos(:one)
  end

  test "should get index" do
    get m_elementos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_elemento_url
    assert_response :success
  end

  test "should create m_elemento" do
    assert_difference('MElemento.count') do
      post m_elementos_url, params: { m_elemento: { m_elemento: @m_elemento.m_elemento, m_formato_id: @m_elemento.m_formato_id, orden: @m_elemento.orden, tipo: @m_elemento.tipo } }
    end

    assert_redirected_to m_elemento_url(MElemento.last)
  end

  test "should show m_elemento" do
    get m_elemento_url(@m_elemento)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_elemento_url(@m_elemento)
    assert_response :success
  end

  test "should update m_elemento" do
    patch m_elemento_url(@m_elemento), params: { m_elemento: { m_elemento: @m_elemento.m_elemento, m_formato_id: @m_elemento.m_formato_id, orden: @m_elemento.orden, tipo: @m_elemento.tipo } }
    assert_redirected_to m_elemento_url(@m_elemento)
  end

  test "should destroy m_elemento" do
    assert_difference('MElemento.count', -1) do
      delete m_elemento_url(@m_elemento)
    end

    assert_redirected_to m_elementos_url
  end
end
