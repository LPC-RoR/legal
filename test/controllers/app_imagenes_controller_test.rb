require 'test_helper'

class AppImagenesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_imagen = app_imagenes(:one)
  end

  test "should get index" do
    get app_imagenes_url
    assert_response :success
  end

  test "should get new" do
    get new_app_imagen_url
    assert_response :success
  end

  test "should create app_imagen" do
    assert_difference('AppImagen.count') do
      post app_imagenes_url, params: { app_imagen: { credito_imagen: @app_imagen.credito_imagen, imagen: @app_imagen.imagen, nombre: @app_imagen.nombre, owner_class: @app_imagen.owner_class, owner_id: @app_imagen.owner_id } }
    end

    assert_redirected_to app_imagen_url(AppImagen.last)
  end

  test "should show app_imagen" do
    get app_imagen_url(@app_imagen)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_imagen_url(@app_imagen)
    assert_response :success
  end

  test "should update app_imagen" do
    patch app_imagen_url(@app_imagen), params: { app_imagen: { credito_imagen: @app_imagen.credito_imagen, imagen: @app_imagen.imagen, nombre: @app_imagen.nombre, owner_class: @app_imagen.owner_class, owner_id: @app_imagen.owner_id } }
    assert_redirected_to app_imagen_url(@app_imagen)
  end

  test "should destroy app_imagen" do
    assert_difference('AppImagen.count', -1) do
      delete app_imagen_url(@app_imagen)
    end

    assert_redirected_to app_imagenes_url
  end
end
