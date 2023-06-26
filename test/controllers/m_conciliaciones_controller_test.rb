require 'test_helper'

class MConciliacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_conciliacion = m_conciliaciones(:one)
  end

  test "should get index" do
    get m_conciliaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_m_conciliacion_url
    assert_response :success
  end

  test "should create m_conciliacion" do
    assert_difference('MConciliacion.count') do
      post m_conciliaciones_url, params: { m_conciliacion: { m_conciliacion: @m_conciliacion.m_conciliacion } }
    end

    assert_redirected_to m_conciliacion_url(MConciliacion.last)
  end

  test "should show m_conciliacion" do
    get m_conciliacion_url(@m_conciliacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_conciliacion_url(@m_conciliacion)
    assert_response :success
  end

  test "should update m_conciliacion" do
    patch m_conciliacion_url(@m_conciliacion), params: { m_conciliacion: { m_conciliacion: @m_conciliacion.m_conciliacion } }
    assert_redirected_to m_conciliacion_url(@m_conciliacion)
  end

  test "should destroy m_conciliacion" do
    assert_difference('MConciliacion.count', -1) do
      delete m_conciliacion_url(@m_conciliacion)
    end

    assert_redirected_to m_conciliaciones_url
  end
end
