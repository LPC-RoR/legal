require 'test_helper'

class AppMensajesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_mensaje = app_mensajes(:one)
  end

  test "should get index" do
    get app_mensajes_url
    assert_response :success
  end

  test "should get new" do
    get new_app_mensaje_url
    assert_response :success
  end

  test "should create app_mensaje" do
    assert_difference('AppMensaje.count') do
      post app_mensajes_url, params: { app_mensaje: { app_perfil_id: @app_mensaje.app_perfil_id, detalle: @app_mensaje.detalle, email: @app_mensaje.email, estado: @app_mensaje.estado, fecha_envio: @app_mensaje.fecha_envio, mensaje: @app_mensaje.mensaje, tipo: @app_mensaje.tipo } }
    end

    assert_redirected_to app_mensaje_url(AppMensaje.last)
  end

  test "should show app_mensaje" do
    get app_mensaje_url(@app_mensaje)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_mensaje_url(@app_mensaje)
    assert_response :success
  end

  test "should update app_mensaje" do
    patch app_mensaje_url(@app_mensaje), params: { app_mensaje: { app_perfil_id: @app_mensaje.app_perfil_id, detalle: @app_mensaje.detalle, email: @app_mensaje.email, estado: @app_mensaje.estado, fecha_envio: @app_mensaje.fecha_envio, mensaje: @app_mensaje.mensaje, tipo: @app_mensaje.tipo } }
    assert_redirected_to app_mensaje_url(@app_mensaje)
  end

  test "should destroy app_mensaje" do
    assert_difference('AppMensaje.count', -1) do
      delete app_mensaje_url(@app_mensaje)
    end

    assert_redirected_to app_mensajes_url
  end
end
