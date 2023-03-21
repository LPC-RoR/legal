require 'test_helper'

class TarValorCuantiasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_valor_cuantia = tar_valor_cuantias(:one)
  end

  test "should get index" do
    get tar_valor_cuantias_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_valor_cuantia_url
    assert_response :success
  end

  test "should create tar_valor_cuantia" do
    assert_difference('TarValorCuantia.count') do
      post tar_valor_cuantias_url, params: { tar_valor_cuantia: { otro_detalle: @tar_valor_cuantia.otro_detalle, owner_class: @tar_valor_cuantia.owner_class, owner_id: @tar_valor_cuantia.owner_id, tar_detalle_cuantia_id: @tar_valor_cuantia.tar_detalle_cuantia_id, valor: @tar_valor_cuantia.valor, valor_uf: @tar_valor_cuantia.valor_uf } }
    end

    assert_redirected_to tar_valor_cuantia_url(TarValorCuantia.last)
  end

  test "should show tar_valor_cuantia" do
    get tar_valor_cuantia_url(@tar_valor_cuantia)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_valor_cuantia_url(@tar_valor_cuantia)
    assert_response :success
  end

  test "should update tar_valor_cuantia" do
    patch tar_valor_cuantia_url(@tar_valor_cuantia), params: { tar_valor_cuantia: { otro_detalle: @tar_valor_cuantia.otro_detalle, owner_class: @tar_valor_cuantia.owner_class, owner_id: @tar_valor_cuantia.owner_id, tar_detalle_cuantia_id: @tar_valor_cuantia.tar_detalle_cuantia_id, valor: @tar_valor_cuantia.valor, valor_uf: @tar_valor_cuantia.valor_uf } }
    assert_redirected_to tar_valor_cuantia_url(@tar_valor_cuantia)
  end

  test "should destroy tar_valor_cuantia" do
    assert_difference('TarValorCuantia.count', -1) do
      delete tar_valor_cuantia_url(@tar_valor_cuantia)
    end

    assert_redirected_to tar_valor_cuantias_url
  end
end
