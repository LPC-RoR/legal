require 'test_helper'

class AppEscaneosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_escaneo = app_escaneos(:one)
  end

  test "should get index" do
    get app_escaneos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_escaneo_url
    assert_response :success
  end

  test "should create app_escaneo" do
    assert_difference('AppEscaneo.count') do
      post app_escaneos_url, params: { app_escaneo: { ownr_class: @app_escaneo.ownr_class, ownr_id: @app_escaneo.ownr_id } }
    end

    assert_redirected_to app_escaneo_url(AppEscaneo.last)
  end

  test "should show app_escaneo" do
    get app_escaneo_url(@app_escaneo)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_escaneo_url(@app_escaneo)
    assert_response :success
  end

  test "should update app_escaneo" do
    patch app_escaneo_url(@app_escaneo), params: { app_escaneo: { ownr_class: @app_escaneo.ownr_class, ownr_id: @app_escaneo.ownr_id } }
    assert_redirected_to app_escaneo_url(@app_escaneo)
  end

  test "should destroy app_escaneo" do
    assert_difference('AppEscaneo.count', -1) do
      delete app_escaneo_url(@app_escaneo)
    end

    assert_redirected_to app_escaneos_url
  end
end
