require 'test_helper'

class TarUfSistemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_uf_sistema = tar_uf_sistemas(:one)
  end

  test "should get index" do
    get tar_uf_sistemas_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_uf_sistema_url
    assert_response :success
  end

  test "should create tar_uf_sistema" do
    assert_difference('TarUfSistema.count') do
      post tar_uf_sistemas_url, params: { tar_uf_sistema: { fecha: @tar_uf_sistema.fecha, valor: @tar_uf_sistema.valor } }
    end

    assert_redirected_to tar_uf_sistema_url(TarUfSistema.last)
  end

  test "should show tar_uf_sistema" do
    get tar_uf_sistema_url(@tar_uf_sistema)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_uf_sistema_url(@tar_uf_sistema)
    assert_response :success
  end

  test "should update tar_uf_sistema" do
    patch tar_uf_sistema_url(@tar_uf_sistema), params: { tar_uf_sistema: { fecha: @tar_uf_sistema.fecha, valor: @tar_uf_sistema.valor } }
    assert_redirected_to tar_uf_sistema_url(@tar_uf_sistema)
  end

  test "should destroy tar_uf_sistema" do
    assert_difference('TarUfSistema.count', -1) do
      delete tar_uf_sistema_url(@tar_uf_sistema)
    end

    assert_redirected_to tar_uf_sistemas_url
  end
end
