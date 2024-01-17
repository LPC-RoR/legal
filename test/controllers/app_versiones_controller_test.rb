require 'test_helper'

class AppVersionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_version = app_versiones(:one)
  end

  test "should get index" do
    get app_versiones_url
    assert_response :success
  end

  test "should get new" do
    get new_app_version_url
    assert_response :success
  end

  test "should create app_version" do
    assert_difference('AppVersion.count') do
      post app_versiones_url, params: { app_version: { app_banner: @app_version.app_banner, app_logo: @app_version.app_logo, app_nombre: @app_version.app_nombre, app_sigla: @app_version.app_sigla, dog_email: @app_version.dog_email } }
    end

    assert_redirected_to app_version_url(AppVersion.last)
  end

  test "should show app_version" do
    get app_version_url(@app_version)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_version_url(@app_version)
    assert_response :success
  end

  test "should update app_version" do
    patch app_version_url(@app_version), params: { app_version: { app_banner: @app_version.app_banner, app_logo: @app_version.app_logo, app_nombre: @app_version.app_nombre, app_sigla: @app_version.app_sigla, dog_email: @app_version.dog_email } }
    assert_redirected_to app_version_url(@app_version)
  end

  test "should destroy app_version" do
    assert_difference('AppVersion.count', -1) do
      delete app_version_url(@app_version)
    end

    assert_redirected_to app_versiones_url
  end
end
