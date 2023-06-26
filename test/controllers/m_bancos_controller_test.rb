require 'test_helper'

class MBancosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_banco = m_bancos(:one)
  end

  test "should get index" do
    get m_bancos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_banco_url
    assert_response :success
  end

  test "should create m_banco" do
    assert_difference('MBanco.count') do
      post m_bancos_url, params: { m_banco: { m_banco: @m_banco.m_banco, m_modelo_id: @m_banco.m_modelo_id } }
    end

    assert_redirected_to m_banco_url(MBanco.last)
  end

  test "should show m_banco" do
    get m_banco_url(@m_banco)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_banco_url(@m_banco)
    assert_response :success
  end

  test "should update m_banco" do
    patch m_banco_url(@m_banco), params: { m_banco: { m_banco: @m_banco.m_banco, m_modelo_id: @m_banco.m_modelo_id } }
    assert_redirected_to m_banco_url(@m_banco)
  end

  test "should destroy m_banco" do
    assert_difference('MBanco.count', -1) do
      delete m_banco_url(@m_banco)
    end

    assert_redirected_to m_bancos_url
  end
end
