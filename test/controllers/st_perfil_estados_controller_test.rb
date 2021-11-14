require 'test_helper'

class StPerfilEstadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_perfil_estado = st_perfil_estados(:one)
  end

  test "should get index" do
    get st_perfil_estados_url
    assert_response :success
  end

  test "should get new" do
    get new_st_perfil_estado_url
    assert_response :success
  end

  test "should create st_perfil_estado" do
    assert_difference('StPerfilEstado.count') do
      post st_perfil_estados_url, params: { st_perfil_estado: { rol: @st_perfil_estado.rol, st_perfil_estado: @st_perfil_estado.st_perfil_estado, st_perfil_modelo_id: @st_perfil_estado.st_perfil_modelo_id } }
    end

    assert_redirected_to st_perfil_estado_url(StPerfilEstado.last)
  end

  test "should show st_perfil_estado" do
    get st_perfil_estado_url(@st_perfil_estado)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_perfil_estado_url(@st_perfil_estado)
    assert_response :success
  end

  test "should update st_perfil_estado" do
    patch st_perfil_estado_url(@st_perfil_estado), params: { st_perfil_estado: { rol: @st_perfil_estado.rol, st_perfil_estado: @st_perfil_estado.st_perfil_estado, st_perfil_modelo_id: @st_perfil_estado.st_perfil_modelo_id } }
    assert_redirected_to st_perfil_estado_url(@st_perfil_estado)
  end

  test "should destroy st_perfil_estado" do
    assert_difference('StPerfilEstado.count', -1) do
      delete st_perfil_estado_url(@st_perfil_estado)
    end

    assert_redirected_to st_perfil_estados_url
  end
end
