require 'test_helper'

class MFormatosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_formato = m_formatos(:one)
  end

  test "should get index" do
    get m_formatos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_formato_url
    assert_response :success
  end

  test "should create m_formato" do
    assert_difference('MFormato.count') do
      post m_formatos_url, params: { m_formato: { m_banco_id: @m_formato.m_banco_id, m_formato: @m_formato.m_formato } }
    end

    assert_redirected_to m_formato_url(MFormato.last)
  end

  test "should show m_formato" do
    get m_formato_url(@m_formato)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_formato_url(@m_formato)
    assert_response :success
  end

  test "should update m_formato" do
    patch m_formato_url(@m_formato), params: { m_formato: { m_banco_id: @m_formato.m_banco_id, m_formato: @m_formato.m_formato } }
    assert_redirected_to m_formato_url(@m_formato)
  end

  test "should destroy m_formato" do
    assert_difference('MFormato.count', -1) do
      delete m_formato_url(@m_formato)
    end

    assert_redirected_to m_formatos_url
  end
end
