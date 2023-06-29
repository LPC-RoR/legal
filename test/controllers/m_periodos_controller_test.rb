require 'test_helper'

class MPeriodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_periodo = m_periodos(:one)
  end

  test "should get index" do
    get m_periodos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_periodo_url
    assert_response :success
  end

  test "should create m_periodo" do
    assert_difference('MPeriodo.count') do
      post m_periodos_url, params: { m_periodo: { clave: @m_periodo.clave, m_modelo_id: @m_periodo.m_modelo_id, m_periodo: @m_periodo.m_periodo } }
    end

    assert_redirected_to m_periodo_url(MPeriodo.last)
  end

  test "should show m_periodo" do
    get m_periodo_url(@m_periodo)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_periodo_url(@m_periodo)
    assert_response :success
  end

  test "should update m_periodo" do
    patch m_periodo_url(@m_periodo), params: { m_periodo: { clave: @m_periodo.clave, m_modelo_id: @m_periodo.m_modelo_id, m_periodo: @m_periodo.m_periodo } }
    assert_redirected_to m_periodo_url(@m_periodo)
  end

  test "should destroy m_periodo" do
    assert_difference('MPeriodo.count', -1) do
      delete m_periodo_url(@m_periodo)
    end

    assert_redirected_to m_periodos_url
  end
end
