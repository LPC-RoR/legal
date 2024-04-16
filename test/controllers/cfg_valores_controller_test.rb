require 'test_helper'

class CfgValoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cfg_valor = cfg_valores(:one)
  end

  test "should get index" do
    get cfg_valores_url
    assert_response :success
  end

  test "should get new" do
    get new_cfg_valor_url
    assert_response :success
  end

  test "should create cfg_valor" do
    assert_difference('CfgValor.count') do
      post cfg_valores_url, params: { cfg_valor: { app_version_id: @cfg_valor.app_version_id, cfg_valor: @cfg_valor.cfg_valor, check_box: @cfg_valor.check_box, fecha: @cfg_valor.fecha, fecha_hora: @cfg_valor.fecha_hora, numero: @cfg_valor.numero, palabra: @cfg_valor.palabra, texto: @cfg_valor.texto, tipo: @cfg_valor.tipo } }
    end

    assert_redirected_to cfg_valor_url(CfgValor.last)
  end

  test "should show cfg_valor" do
    get cfg_valor_url(@cfg_valor)
    assert_response :success
  end

  test "should get edit" do
    get edit_cfg_valor_url(@cfg_valor)
    assert_response :success
  end

  test "should update cfg_valor" do
    patch cfg_valor_url(@cfg_valor), params: { cfg_valor: { app_version_id: @cfg_valor.app_version_id, cfg_valor: @cfg_valor.cfg_valor, check_box: @cfg_valor.check_box, fecha: @cfg_valor.fecha, fecha_hora: @cfg_valor.fecha_hora, numero: @cfg_valor.numero, palabra: @cfg_valor.palabra, texto: @cfg_valor.texto, tipo: @cfg_valor.tipo } }
    assert_redirected_to cfg_valor_url(@cfg_valor)
  end

  test "should destroy cfg_valor" do
    assert_difference('CfgValor.count', -1) do
      delete cfg_valor_url(@cfg_valor)
    end

    assert_redirected_to cfg_valores_url
  end
end
