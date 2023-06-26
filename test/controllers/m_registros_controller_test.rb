require 'test_helper'

class MRegistrosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_registro = m_registros(:one)
  end

  test "should get index" do
    get m_registros_url
    assert_response :success
  end

  test "should get new" do
    get new_m_registro_url
    assert_response :success
  end

  test "should create m_registro" do
    assert_difference('MRegistro.count') do
      post m_registros_url, params: { m_registro: { cargo_abono: @m_registro.cargo_abono, documento: @m_registro.documento, fecha: @m_registro.fecha, glosa: @m_registro.glosa, glosa_banco: @m_registro.glosa_banco, m_conciliacion_id: @m_registro.m_conciliacion_id, m_registro: @m_registro.m_registro, monto: @m_registro.monto, orden: @m_registro.orden, saldo: @m_registro.saldo } }
    end

    assert_redirected_to m_registro_url(MRegistro.last)
  end

  test "should show m_registro" do
    get m_registro_url(@m_registro)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_registro_url(@m_registro)
    assert_response :success
  end

  test "should update m_registro" do
    patch m_registro_url(@m_registro), params: { m_registro: { cargo_abono: @m_registro.cargo_abono, documento: @m_registro.documento, fecha: @m_registro.fecha, glosa: @m_registro.glosa, glosa_banco: @m_registro.glosa_banco, m_conciliacion_id: @m_registro.m_conciliacion_id, m_registro: @m_registro.m_registro, monto: @m_registro.monto, orden: @m_registro.orden, saldo: @m_registro.saldo } }
    assert_redirected_to m_registro_url(@m_registro)
  end

  test "should destroy m_registro" do
    assert_difference('MRegistro.count', -1) do
      delete m_registro_url(@m_registro)
    end

    assert_redirected_to m_registros_url
  end
end
