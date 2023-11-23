require 'test_helper'

class MRegFactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_reg_fact = m_reg_facts(:one)
  end

  test "should get index" do
    get m_reg_facts_url
    assert_response :success
  end

  test "should get new" do
    get new_m_reg_fact_url
    assert_response :success
  end

  test "should create m_reg_fact" do
    assert_difference('MRegFact.count') do
      post m_reg_facts_url, params: { m_reg_fact: { m_registro_id: @m_reg_fact.m_registro_id, monto: @m_reg_fact.monto, tar_factura: @m_reg_fact.tar_factura } }
    end

    assert_redirected_to m_reg_fact_url(MRegFact.last)
  end

  test "should show m_reg_fact" do
    get m_reg_fact_url(@m_reg_fact)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_reg_fact_url(@m_reg_fact)
    assert_response :success
  end

  test "should update m_reg_fact" do
    patch m_reg_fact_url(@m_reg_fact), params: { m_reg_fact: { m_registro_id: @m_reg_fact.m_registro_id, monto: @m_reg_fact.monto, tar_factura: @m_reg_fact.tar_factura } }
    assert_redirected_to m_reg_fact_url(@m_reg_fact)
  end

  test "should destroy m_reg_fact" do
    assert_difference('MRegFact.count', -1) do
      delete m_reg_fact_url(@m_reg_fact)
    end

    assert_redirected_to m_reg_facts_url
  end
end
