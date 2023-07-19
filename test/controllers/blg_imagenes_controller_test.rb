require 'test_helper'

class BlgImagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blg_imagen = blg_imagenes(:one)
  end

  test "should get index" do
    get blg_imagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_blg_imagen_url
    assert_response :success
  end

  test "should create blg_imagen" do
    assert_difference('BlgImagen.count') do
      post blg_imagenes_url, params: { blg_imagen: { blg_credito: @blg_imagen.blg_credito, blg_imagen: @blg_imagen.blg_imagen, imagen: @blg_imagen.imagen, ownr_class: @blg_imagen.ownr_class, ownr_id: @blg_imagen.ownr_id } }
    end

    assert_redirected_to blg_imagen_url(BlgImagen.last)
  end

  test "should show blg_imagen" do
    get blg_imagen_url(@blg_imagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_blg_imagen_url(@blg_imagen)
    assert_response :success
  end

  test "should update blg_imagen" do
    patch blg_imagen_url(@blg_imagen), params: { blg_imagen: { blg_credito: @blg_imagen.blg_credito, blg_imagen: @blg_imagen.blg_imagen, imagen: @blg_imagen.imagen, ownr_class: @blg_imagen.ownr_class, ownr_id: @blg_imagen.ownr_id } }
    assert_redirected_to blg_imagen_url(@blg_imagen)
  end

  test "should destroy blg_imagen" do
    assert_difference('BlgImagen.count', -1) do
      delete blg_imagen_url(@blg_imagen)
    end

    assert_redirected_to blg_imagenes_url
  end
end
