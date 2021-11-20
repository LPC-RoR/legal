require 'test_helper'

class TarElementosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_elemento = tar_elementos(:one)
  end

  test "should get index" do
    get tar_elementos_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_elemento_url
    assert_response :success
  end

  test "should create tar_elemento" do
    assert_difference('TarElemento.count') do
      post tar_elementos_url, params: { tar_elemento: { codigo: @tar_elemento.codigo, elemento: @tar_elemento.elemento, orden: @tar_elemento.orden } }
    end

    assert_redirected_to tar_elemento_url(TarElemento.last)
  end

  test "should show tar_elemento" do
    get tar_elemento_url(@tar_elemento)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_elemento_url(@tar_elemento)
    assert_response :success
  end

  test "should update tar_elemento" do
    patch tar_elemento_url(@tar_elemento), params: { tar_elemento: { codigo: @tar_elemento.codigo, elemento: @tar_elemento.elemento, orden: @tar_elemento.orden } }
    assert_redirected_to tar_elemento_url(@tar_elemento)
  end

  test "should destroy tar_elemento" do
    assert_difference('TarElemento.count', -1) do
      delete tar_elemento_url(@tar_elemento)
    end

    assert_redirected_to tar_elementos_url
  end
end
