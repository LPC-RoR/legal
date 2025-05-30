require "test_helper"

class RcrsLogosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rcrs_logo = rcrs_logos(:one)
  end

  test "should get index" do
    get rcrs_logos_url
    assert_response :success
  end

  test "should get new" do
    get new_rcrs_logo_url
    assert_response :success
  end

  test "should create rcrs_logo" do
    assert_difference("RcrsLogo.count") do
      post rcrs_logos_url, params: { rcrs_logo: { logo: @rcrs_logo.logo, ownr_id: @rcrs_logo.ownr_id, ownr_type: @rcrs_logo.ownr_type } }
    end

    assert_redirected_to rcrs_logo_url(RcrsLogo.last)
  end

  test "should show rcrs_logo" do
    get rcrs_logo_url(@rcrs_logo)
    assert_response :success
  end

  test "should get edit" do
    get edit_rcrs_logo_url(@rcrs_logo)
    assert_response :success
  end

  test "should update rcrs_logo" do
    patch rcrs_logo_url(@rcrs_logo), params: { rcrs_logo: { logo: @rcrs_logo.logo, ownr_id: @rcrs_logo.ownr_id, ownr_type: @rcrs_logo.ownr_type } }
    assert_redirected_to rcrs_logo_url(@rcrs_logo)
  end

  test "should destroy rcrs_logo" do
    assert_difference("RcrsLogo.count", -1) do
      delete rcrs_logo_url(@rcrs_logo)
    end

    assert_redirected_to rcrs_logos_url
  end
end
