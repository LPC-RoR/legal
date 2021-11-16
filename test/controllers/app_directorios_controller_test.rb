require 'test_helper'

class AppDirectoriosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_directorio = app_directorios(:one)
  end

  test "should get index" do
    get app_directorios_url
    assert_response :success
  end

  test "should get new" do
    get new_app_directorio_url
    assert_response :success
  end

  test "should create app_directorio" do
    assert_difference('AppDirectorio.count') do
      post app_directorios_url, params: { app_directorio: { app_repo_id: @app_directorio.app_repo_id, directorio: @app_directorio.directorio } }
    end

    assert_redirected_to app_directorio_url(AppDirectorio.last)
  end

  test "should show app_directorio" do
    get app_directorio_url(@app_directorio)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_directorio_url(@app_directorio)
    assert_response :success
  end

  test "should update app_directorio" do
    patch app_directorio_url(@app_directorio), params: { app_directorio: { app_repo_id: @app_directorio.app_repo_id, directorio: @app_directorio.directorio } }
    assert_redirected_to app_directorio_url(@app_directorio)
  end

  test "should destroy app_directorio" do
    assert_difference('AppDirectorio.count', -1) do
      delete app_directorio_url(@app_directorio)
    end

    assert_redirected_to app_directorios_url
  end
end
