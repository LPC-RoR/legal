require 'test_helper'

class SbListasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sb_lista = sb_listas(:one)
  end

  test "should get index" do
    get sb_listas_url
    assert_response :success
  end

  test "should get new" do
    get new_sb_lista_url
    assert_response :success
  end

  test "should create sb_lista" do
    assert_difference('SbLista.count') do
      post sb_listas_url, params: { sb_lista: { acceso: @sb_lista.acceso, activa: @sb_lista.activa, link: @sb_lista.link, lista: @sb_lista.lista } }
    end

    assert_redirected_to sb_lista_url(SbLista.last)
  end

  test "should show sb_lista" do
    get sb_lista_url(@sb_lista)
    assert_response :success
  end

  test "should get edit" do
    get edit_sb_lista_url(@sb_lista)
    assert_response :success
  end

  test "should update sb_lista" do
    patch sb_lista_url(@sb_lista), params: { sb_lista: { acceso: @sb_lista.acceso, activa: @sb_lista.activa, link: @sb_lista.link, lista: @sb_lista.lista } }
    assert_redirected_to sb_lista_url(@sb_lista)
  end

  test "should destroy sb_lista" do
    assert_difference('SbLista.count', -1) do
      delete sb_lista_url(@sb_lista)
    end

    assert_redirected_to sb_listas_url
  end
end
