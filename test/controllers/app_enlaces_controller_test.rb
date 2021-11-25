require 'test_helper'

class AppEnlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_enlace = app_enlaces(:one)
  end

  test "should get index" do
    get app_enlaces_url
    assert_response :success
  end

  test "should get new" do
    get new_app_enlace_url
    assert_response :success
  end

  test "should create app_enlace" do
    assert_difference('AppEnlace.count') do
      post app_enlaces_url, params: { app_enlace: { descripcion: @app_enlace.descripcion, enlace: @app_enlace.enlace, owner_class: @app_enlace.owner_class, owner_id: @app_enlace.owner_id } }
    end

    assert_redirected_to app_enlace_url(AppEnlace.last)
  end

  test "should show app_enlace" do
    get app_enlace_url(@app_enlace)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_enlace_url(@app_enlace)
    assert_response :success
  end

  test "should update app_enlace" do
    patch app_enlace_url(@app_enlace), params: { app_enlace: { descripcion: @app_enlace.descripcion, enlace: @app_enlace.enlace, owner_class: @app_enlace.owner_class, owner_id: @app_enlace.owner_id } }
    assert_redirected_to app_enlace_url(@app_enlace)
  end

  test "should destroy app_enlace" do
    assert_difference('AppEnlace.count', -1) do
      delete app_enlace_url(@app_enlace)
    end

    assert_redirected_to app_enlaces_url
  end
end
