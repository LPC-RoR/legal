require 'test_helper'

class BlgArticulosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blg_articulo = blg_articulos(:one)
  end

  test "should get index" do
    get blg_articulos_url
    assert_response :success
  end

  test "should get new" do
    get new_blg_articulo_url
    assert_response :success
  end

  test "should create blg_articulo" do
    assert_difference('BlgArticulo.count') do
      post blg_articulos_url, params: { blg_articulo: { app_perfil_id: @blg_articulo.app_perfil_id, articulo: @blg_articulo.articulo, blg_articulo: @blg_articulo.blg_articulo, blg_tema_id: @blg_articulo.blg_tema_id, estado: @blg_articulo.estado } }
    end

    assert_redirected_to blg_articulo_url(BlgArticulo.last)
  end

  test "should show blg_articulo" do
    get blg_articulo_url(@blg_articulo)
    assert_response :success
  end

  test "should get edit" do
    get edit_blg_articulo_url(@blg_articulo)
    assert_response :success
  end

  test "should update blg_articulo" do
    patch blg_articulo_url(@blg_articulo), params: { blg_articulo: { app_perfil_id: @blg_articulo.app_perfil_id, articulo: @blg_articulo.articulo, blg_articulo: @blg_articulo.blg_articulo, blg_tema_id: @blg_articulo.blg_tema_id, estado: @blg_articulo.estado } }
    assert_redirected_to blg_articulo_url(@blg_articulo)
  end

  test "should destroy blg_articulo" do
    assert_difference('BlgArticulo.count', -1) do
      delete blg_articulo_url(@blg_articulo)
    end

    assert_redirected_to blg_articulos_url
  end
end
