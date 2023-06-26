require 'test_helper'

class MModelosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_modelo = m_modelos(:one)
  end

  test "should get index" do
    get m_modelos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_modelo_url
    assert_response :success
  end

  test "should create m_modelo" do
    assert_difference('MModelo.count') do
      post m_modelos_url, params: { m_modelo: { m_modelo: @m_modelo.m_modelo, ownr_class: @m_modelo.ownr_class, ownr_id: @m_modelo.ownr_id } }
    end

    assert_redirected_to m_modelo_url(MModelo.last)
  end

  test "should show m_modelo" do
    get m_modelo_url(@m_modelo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_modelo_url(@m_modelo)
    assert_response :success
  end

  test "should update m_modelo" do
    patch m_modelo_url(@m_modelo), params: { m_modelo: { m_modelo: @m_modelo.m_modelo, ownr_class: @m_modelo.ownr_class, ownr_id: @m_modelo.ownr_id } }
    assert_redirected_to m_modelo_url(@m_modelo)
  end

  test "should destroy m_modelo" do
    assert_difference('MModelo.count', -1) do
      delete m_modelo_url(@m_modelo)
    end

    assert_redirected_to m_modelos_url
  end
end
