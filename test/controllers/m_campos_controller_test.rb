require 'test_helper'

class MCamposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_campo = m_campos(:one)
  end

  test "should get index" do
    get m_campos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_campo_url
    assert_response :success
  end

  test "should create m_campo" do
    assert_difference('MCampo.count') do
      post m_campos_url, params: { m_campo: { m_campo: @m_campo.m_campo, m_conciliacion_id: @m_campo.m_conciliacion_id, valor: @m_campo.valor } }
    end

    assert_redirected_to m_campo_url(MCampo.last)
  end

  test "should show m_campo" do
    get m_campo_url(@m_campo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_campo_url(@m_campo)
    assert_response :success
  end

  test "should update m_campo" do
    patch m_campo_url(@m_campo), params: { m_campo: { m_campo: @m_campo.m_campo, m_conciliacion_id: @m_campo.m_conciliacion_id, valor: @m_campo.valor } }
    assert_redirected_to m_campo_url(@m_campo)
  end

  test "should destroy m_campo" do
    assert_difference('MCampo.count', -1) do
      delete m_campo_url(@m_campo)
    end

    assert_redirected_to m_campos_url
  end
end
