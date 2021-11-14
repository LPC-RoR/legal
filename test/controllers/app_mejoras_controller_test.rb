require 'test_helper'

class AppMejorasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_mejora = app_mejoras(:one)
  end

  test "should get index" do
    get app_mejoras_url
    assert_response :success
  end

  test "should get new" do
    get new_app_mejora_url
    assert_response :success
  end

  test "should create app_mejora" do
    assert_difference('AppMejora.count') do
      post app_mejoras_url, params: { app_mejora: { app_perfil_id: @app_mejora.app_perfil_id, detalle: @app_mejora.detalle, estado: @app_mejora.estado, owner_class: @app_mejora.owner_class, owner_id: @app_mejora.owner_id } }
    end

    assert_redirected_to app_mejora_url(AppMejora.last)
  end

  test "should show app_mejora" do
    get app_mejora_url(@app_mejora)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_mejora_url(@app_mejora)
    assert_response :success
  end

  test "should update app_mejora" do
    patch app_mejora_url(@app_mejora), params: { app_mejora: { app_perfil_id: @app_mejora.app_perfil_id, detalle: @app_mejora.detalle, estado: @app_mejora.estado, owner_class: @app_mejora.owner_class, owner_id: @app_mejora.owner_id } }
    assert_redirected_to app_mejora_url(@app_mejora)
  end

  test "should destroy app_mejora" do
    assert_difference('AppMejora.count', -1) do
      delete app_mejora_url(@app_mejora)
    end

    assert_redirected_to app_mejoras_url
  end
end
