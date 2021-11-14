require 'test_helper'

class StPerfilModelosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_perfil_modelo = st_perfil_modelos(:one)
  end

  test "should get index" do
    get st_perfil_modelos_url
    assert_response :success
  end

  test "should get new" do
    get new_st_perfil_modelo_url
    assert_response :success
  end

  test "should create st_perfil_modelo" do
    assert_difference('StPerfilModelo.count') do
      post st_perfil_modelos_url, params: { st_perfil_modelo: { app_nomina_id: @st_perfil_modelo.app_nomina_id, ingresa_registros: @st_perfil_modelo.ingresa_registros, rol: @st_perfil_modelo.rol, st_perfil_modelo: @st_perfil_modelo.st_perfil_modelo } }
    end

    assert_redirected_to st_perfil_modelo_url(StPerfilModelo.last)
  end

  test "should show st_perfil_modelo" do
    get st_perfil_modelo_url(@st_perfil_modelo)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_perfil_modelo_url(@st_perfil_modelo)
    assert_response :success
  end

  test "should update st_perfil_modelo" do
    patch st_perfil_modelo_url(@st_perfil_modelo), params: { st_perfil_modelo: { app_nomina_id: @st_perfil_modelo.app_nomina_id, ingresa_registros: @st_perfil_modelo.ingresa_registros, rol: @st_perfil_modelo.rol, st_perfil_modelo: @st_perfil_modelo.st_perfil_modelo } }
    assert_redirected_to st_perfil_modelo_url(@st_perfil_modelo)
  end

  test "should destroy st_perfil_modelo" do
    assert_difference('StPerfilModelo.count', -1) do
      delete st_perfil_modelo_url(@st_perfil_modelo)
    end

    assert_redirected_to st_perfil_modelos_url
  end
end
