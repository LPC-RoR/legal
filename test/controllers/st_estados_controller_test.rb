require 'test_helper'

class StEstadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @st_estado = st_estados(:one)
  end

  test "should get index" do
    get st_estados_url
    assert_response :success
  end

  test "should get new" do
    get new_st_estado_url
    assert_response :success
  end

  test "should create st_estado" do
    assert_difference('StEstado.count') do
      post st_estados_url, params: { st_estado: { destinos: @st_estado.destinos, destinos_admin: @st_estado.destinos_admin, orden: @st_estado.orden, st_estado: @st_estado.st_estado, st_modelo_id: @st_estado.st_modelo_id } }
    end

    assert_redirected_to st_estado_url(StEstado.last)
  end

  test "should show st_estado" do
    get st_estado_url(@st_estado)
    assert_response :success
  end

  test "should get edit" do
    get edit_st_estado_url(@st_estado)
    assert_response :success
  end

  test "should update st_estado" do
    patch st_estado_url(@st_estado), params: { st_estado: { destinos: @st_estado.destinos, destinos_admin: @st_estado.destinos_admin, orden: @st_estado.orden, st_estado: @st_estado.st_estado, st_modelo_id: @st_estado.st_modelo_id } }
    assert_redirected_to st_estado_url(@st_estado)
  end

  test "should destroy st_estado" do
    assert_difference('StEstado.count', -1) do
      delete st_estado_url(@st_estado)
    end

    assert_redirected_to st_estados_url
  end
end
