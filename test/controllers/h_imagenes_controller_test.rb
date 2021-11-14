require 'test_helper'

class HImagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @h_imagen = h_imagenes(:one)
  end

  test "should get index" do
    get h_imagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_h_imagen_url
    assert_response :success
  end

  test "should create h_imagen" do
    assert_difference('HImagen.count') do
      post h_imagenes_url, params: { h_imagen: { nombre: @h_imagen.nombre } }
    end

    assert_redirected_to h_imagen_url(HImagen.last)
  end

  test "should show h_imagen" do
    get h_imagen_url(@h_imagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_h_imagen_url(@h_imagen)
    assert_response :success
  end

  test "should update h_imagen" do
    patch h_imagen_url(@h_imagen), params: { h_imagen: { nombre: @h_imagen.nombre } }
    assert_redirected_to h_imagen_url(@h_imagen)
  end

  test "should destroy h_imagen" do
    assert_difference('HImagen.count', -1) do
      delete h_imagen_url(@h_imagen)
    end

    assert_redirected_to h_imagenes_url
  end
end
