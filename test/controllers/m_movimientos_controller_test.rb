require 'test_helper'

class MMovimientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_movimiento = m_movimientos(:one)
  end

  test "should get index" do
    get m_movimientos_url
    assert_response :success
  end

  test "should get new" do
    get new_m_movimiento_url
    assert_response :success
  end

  test "should create m_movimiento" do
    assert_difference('MMovimiento.count') do
      post m_movimientos_url, params: { m_movimiento: { fecha: @m_movimiento.fecha, glosa: @m_movimiento.glosa, m_item_id: @m_movimiento.m_item_id, monto: @m_movimiento.monto } }
    end

    assert_redirected_to m_movimiento_url(MMovimiento.last)
  end

  test "should show m_movimiento" do
    get m_movimiento_url(@m_movimiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_movimiento_url(@m_movimiento)
    assert_response :success
  end

  test "should update m_movimiento" do
    patch m_movimiento_url(@m_movimiento), params: { m_movimiento: { fecha: @m_movimiento.fecha, glosa: @m_movimiento.glosa, m_item_id: @m_movimiento.m_item_id, monto: @m_movimiento.monto } }
    assert_redirected_to m_movimiento_url(@m_movimiento)
  end

  test "should destroy m_movimiento" do
    assert_difference('MMovimiento.count', -1) do
      delete m_movimiento_url(@m_movimiento)
    end

    assert_redirected_to m_movimientos_url
  end
end
