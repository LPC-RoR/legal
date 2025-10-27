require "test_helper"

class RcrsEnlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rcrs_enlace = rcrs_enlaces(:one)
  end

  test "should get index" do
    get rcrs_enlaces_url
    assert_response :success
  end

  test "should get new" do
    get new_rcrs_enlace_url
    assert_response :success
  end

  test "should create rcrs_enlace" do
    assert_difference("RcrsEnlace.count") do
      post rcrs_enlaces_url, params: { rcrs_enlace: { descripcion: @rcrs_enlace.descripcion, link: @rcrs_enlace.link, ownr_id: @rcrs_enlace.ownr_id, ownr_type: @rcrs_enlace.ownr_type } }
    end

    assert_redirected_to rcrs_enlace_url(RcrsEnlace.last)
  end

  test "should show rcrs_enlace" do
    get rcrs_enlace_url(@rcrs_enlace)
    assert_response :success
  end

  test "should get edit" do
    get edit_rcrs_enlace_url(@rcrs_enlace)
    assert_response :success
  end

  test "should update rcrs_enlace" do
    patch rcrs_enlace_url(@rcrs_enlace), params: { rcrs_enlace: { descripcion: @rcrs_enlace.descripcion, link: @rcrs_enlace.link, ownr_id: @rcrs_enlace.ownr_id, ownr_type: @rcrs_enlace.ownr_type } }
    assert_redirected_to rcrs_enlace_url(@rcrs_enlace)
  end

  test "should destroy rcrs_enlace" do
    assert_difference("RcrsEnlace.count", -1) do
      delete rcrs_enlace_url(@rcrs_enlace)
    end

    assert_redirected_to rcrs_enlaces_url
  end
end
