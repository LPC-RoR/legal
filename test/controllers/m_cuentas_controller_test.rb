require 'test_helper'

class MCuentasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_cuenta = m_cuentas(:one)
  end

  test "should get index" do
    get m_cuentas_url
    assert_response :success
  end

  test "should get new" do
    get new_m_cuenta_url
    assert_response :success
  end

  test "should create m_cuenta" do
    assert_difference('MCuenta.count') do
      post m_cuentas_url, params: { m_cuenta: { m_banco_id: @m_cuenta.m_banco_id, m_cuenta: @m_cuenta.m_cuenta } }
    end

    assert_redirected_to m_cuenta_url(MCuenta.last)
  end

  test "should show m_cuenta" do
    get m_cuenta_url(@m_cuenta)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_cuenta_url(@m_cuenta)
    assert_response :success
  end

  test "should update m_cuenta" do
    patch m_cuenta_url(@m_cuenta), params: { m_cuenta: { m_banco_id: @m_cuenta.m_banco_id, m_cuenta: @m_cuenta.m_cuenta } }
    assert_redirected_to m_cuenta_url(@m_cuenta)
  end

  test "should destroy m_cuenta" do
    assert_difference('MCuenta.count', -1) do
      delete m_cuenta_url(@m_cuenta)
    end

    assert_redirected_to m_cuentas_url
  end
end
