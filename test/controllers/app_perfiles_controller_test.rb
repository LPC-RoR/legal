require 'test_helper'

class AppPerfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_perfil = app_perfiles(:one)
  end

  test "should get index" do
    get app_perfiles_url
    assert_response :success
  end

  test "should get new" do
    get new_app_perfil_url
    assert_response :success
  end

  test "should create app_perfil" do
    assert_difference('AppPerfil.count') do
      post app_perfiles_url, params: { app_perfil: { app_administrador_id: @app_perfil.app_administrador_id, email: @app_perfil.email, usuario_id: @app_perfil.usuario_id } }
    end

    assert_redirected_to app_perfil_url(AppPerfil.last)
  end

  test "should show app_perfil" do
    get app_perfil_url(@app_perfil)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_perfil_url(@app_perfil)
    assert_response :success
  end

  test "should update app_perfil" do
    patch app_perfil_url(@app_perfil), params: { app_perfil: { app_administrador_id: @app_perfil.app_administrador_id, email: @app_perfil.email, usuario_id: @app_perfil.usuario_id } }
    assert_redirected_to app_perfil_url(@app_perfil)
  end

  test "should destroy app_perfil" do
    assert_difference('AppPerfil.count', -1) do
      delete app_perfil_url(@app_perfil)
    end

    assert_redirected_to app_perfiles_url
  end
end
