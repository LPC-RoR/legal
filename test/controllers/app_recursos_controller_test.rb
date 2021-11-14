require 'test_helper'

class AppRecursosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_recurso = app_recursos(:one)
  end

  test "should get index" do
    get app_recursos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_recurso_url
    assert_response :success
  end

  test "should create app_recurso" do
    assert_difference('AppRecurso.count') do
      post app_recursos_url, params: { app_recurso: {  } }
    end

    assert_redirected_to app_recurso_url(AppRecurso.last)
  end

  test "should show app_recurso" do
    get app_recurso_url(@app_recurso)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_recurso_url(@app_recurso)
    assert_response :success
  end

  test "should update app_recurso" do
    patch app_recurso_url(@app_recurso), params: { app_recurso: {  } }
    assert_redirected_to app_recurso_url(@app_recurso)
  end

  test "should destroy app_recurso" do
    assert_difference('AppRecurso.count', -1) do
      delete app_recurso_url(@app_recurso)
    end

    assert_redirected_to app_recursos_url
  end
end
