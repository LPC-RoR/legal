require 'test_helper'

class AppDirDiresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_dir_dir = app_dir_dires(:one)
  end

  test "should get index" do
    get app_dir_dires_url
    assert_response :success
  end

  test "should get new" do
    get new_app_dir_dir_url
    assert_response :success
  end

  test "should create app_dir_dir" do
    assert_difference('AppDirDir.count') do
      post app_dir_dires_url, params: { app_dir_dir: { child_id: @app_dir_dir.child_id, parent_id: @app_dir_dir.parent_id } }
    end

    assert_redirected_to app_dir_dir_url(AppDirDir.last)
  end

  test "should show app_dir_dir" do
    get app_dir_dir_url(@app_dir_dir)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_dir_dir_url(@app_dir_dir)
    assert_response :success
  end

  test "should update app_dir_dir" do
    patch app_dir_dir_url(@app_dir_dir), params: { app_dir_dir: { child_id: @app_dir_dir.child_id, parent_id: @app_dir_dir.parent_id } }
    assert_redirected_to app_dir_dir_url(@app_dir_dir)
  end

  test "should destroy app_dir_dir" do
    assert_difference('AppDirDir.count', -1) do
      delete app_dir_dir_url(@app_dir_dir)
    end

    assert_redirected_to app_dir_dires_url
  end
end
