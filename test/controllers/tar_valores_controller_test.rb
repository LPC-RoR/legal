require 'test_helper'

class TarValoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_valor = tar_valores(:one)
  end

  test "should get index" do
    get tar_valores_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_valor_url
    assert_response :success
  end

  test "should create tar_valor" do
    assert_difference('TarValor.count') do
      post tar_valores_url, params: { tar_valor: { codigo: @tar_valor.codigo, detalle: @tar_valor.detalle, owner_class: @tar_valor.owner_class, owner_id: @tar_valor.owner_id, valor: @tar_valor.valor, valor_uf: @tar_valor.valor_uf } }
    end

    assert_redirected_to tar_valor_url(TarValor.last)
  end

  test "should show tar_valor" do
    get tar_valor_url(@tar_valor)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_valor_url(@tar_valor)
    assert_response :success
  end

  test "should update tar_valor" do
    patch tar_valor_url(@tar_valor), params: { tar_valor: { codigo: @tar_valor.codigo, detalle: @tar_valor.detalle, owner_class: @tar_valor.owner_class, owner_id: @tar_valor.owner_id, valor: @tar_valor.valor, valor_uf: @tar_valor.valor_uf } }
    assert_redirected_to tar_valor_url(@tar_valor)
  end

  test "should destroy tar_valor" do
    assert_difference('TarValor.count', -1) do
      delete tar_valor_url(@tar_valor)
    end

    assert_redirected_to tar_valores_url
  end
end
