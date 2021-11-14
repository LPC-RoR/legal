require 'test_helper'

class AppAdministradoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_administrador = app_administradores(:one)
  end

  test "should get index" do
    get app_administradores_url
    assert_response :success
  end

  test "should get new" do
    get new_app_administrador_url
    assert_response :success
  end

  test "should create app_administrador" do
    assert_difference('AppAdministrador.count') do
      post app_administradores_url, params: { app_administrador: { administrador: @app_administrador.administrador, email: @app_administrador.email, usuario_id: @app_administrador.usuario_id } }
    end

    assert_redirected_to app_administrador_url(AppAdministrador.last)
  end

  test "should show app_administrador" do
    get app_administrador_url(@app_administrador)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_administrador_url(@app_administrador)
    assert_response :success
  end

  test "should update app_administrador" do
    patch app_administrador_url(@app_administrador), params: { app_administrador: { administrador: @app_administrador.administrador, email: @app_administrador.email, usuario_id: @app_administrador.usuario_id } }
    assert_redirected_to app_administrador_url(@app_administrador)
  end

  test "should destroy app_administrador" do
    assert_difference('AppAdministrador.count', -1) do
      delete app_administrador_url(@app_administrador)
    end

    assert_redirected_to app_administradores_url
  end
end
