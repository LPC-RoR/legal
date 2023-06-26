require 'test_helper'

class MConceptosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_concepto = m_conceptos(:one)
  end

  test "should get index" do
    get m_conceptos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_concepto_url
    assert_response :success
  end

  test "should create m_concepto" do
    assert_difference('MConcepto.count') do
      post m_conceptos_url, params: { m_concepto: { m_concepto: @m_concepto.m_concepto, m_modelo_id: @m_concepto.m_modelo_id } }
    end

    assert_redirected_to m_concepto_url(MConcepto.last)
  end

  test "should show m_concepto" do
    get m_concepto_url(@m_concepto)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_concepto_url(@m_concepto)
    assert_response :success
  end

  test "should update m_concepto" do
    patch m_concepto_url(@m_concepto), params: { m_concepto: { m_concepto: @m_concepto.m_concepto, m_modelo_id: @m_concepto.m_modelo_id } }
    assert_redirected_to m_concepto_url(@m_concepto)
  end

  test "should destroy m_concepto" do
    assert_difference('MConcepto.count', -1) do
      delete m_concepto_url(@m_concepto)
    end

    assert_redirected_to m_conceptos_url
  end
end
