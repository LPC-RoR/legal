require 'test_helper'

class SbElementosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sb_elemento = sb_elementos(:one)
  end

  test "should get index" do
    get sb_elementos_url
    assert_response :success
  end

  test "should get new" do
    get new_sb_elemento_url
    assert_response :success
  end

  test "should create sb_elemento" do
    assert_difference('SbElemento.count') do
      post sb_elementos_url, params: { sb_elemento: { acceso: @sb_elemento.acceso, activo: @sb_elemento.activo, controlador: @sb_elemento.controlador, despliegue: @sb_elemento.despliegue, elemento: @sb_elemento.elemento, nivel: @sb_elemento.nivel, orden: @sb_elemento.orden, sb_lista_id: @sb_elemento.sb_lista_id, tipo: @sb_elemento.tipo } }
    end

    assert_redirected_to sb_elemento_url(SbElemento.last)
  end

  test "should show sb_elemento" do
    get sb_elemento_url(@sb_elemento)
    assert_response :success
  end

  test "should get edit" do
    get edit_sb_elemento_url(@sb_elemento)
    assert_response :success
  end

  test "should update sb_elemento" do
    patch sb_elemento_url(@sb_elemento), params: { sb_elemento: { acceso: @sb_elemento.acceso, activo: @sb_elemento.activo, controlador: @sb_elemento.controlador, despliegue: @sb_elemento.despliegue, elemento: @sb_elemento.elemento, nivel: @sb_elemento.nivel, orden: @sb_elemento.orden, sb_lista_id: @sb_elemento.sb_lista_id, tipo: @sb_elemento.tipo } }
    assert_redirected_to sb_elemento_url(@sb_elemento)
  end

  test "should destroy sb_elemento" do
    assert_difference('SbElemento.count', -1) do
      delete sb_elemento_url(@sb_elemento)
    end

    assert_redirected_to sb_elementos_url
  end
end
