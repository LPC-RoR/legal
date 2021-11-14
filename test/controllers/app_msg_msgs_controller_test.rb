require 'test_helper'

class AppMsgMsgsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_msg_msg = app_msg_msgs(:one)
  end

  test "should get index" do
    get app_msg_msgs_url
    assert_response :success
  end

  test "should get new" do
    get new_app_msg_msg_url
    assert_response :success
  end

  test "should create app_msg_msg" do
    assert_difference('AppMsgMsg.count') do
      post app_msg_msgs_url, params: { app_msg_msg: { child_id: @app_msg_msg.child_id, parent_id: @app_msg_msg.parent_id } }
    end

    assert_redirected_to app_msg_msg_url(AppMsgMsg.last)
  end

  test "should show app_msg_msg" do
    get app_msg_msg_url(@app_msg_msg)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_msg_msg_url(@app_msg_msg)
    assert_response :success
  end

  test "should update app_msg_msg" do
    patch app_msg_msg_url(@app_msg_msg), params: { app_msg_msg: { child_id: @app_msg_msg.child_id, parent_id: @app_msg_msg.parent_id } }
    assert_redirected_to app_msg_msg_url(@app_msg_msg)
  end

  test "should destroy app_msg_msg" do
    assert_difference('AppMsgMsg.count', -1) do
      delete app_msg_msg_url(@app_msg_msg)
    end

    assert_redirected_to app_msg_msgs_url
  end
end
