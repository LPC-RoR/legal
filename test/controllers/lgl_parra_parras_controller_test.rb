require "test_helper"

class LglParraParrasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_parra_parra = lgl_parra_parras(:one)
  end

  test "should get index" do
    get lgl_parra_parras_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_parra_parra_url
    assert_response :success
  end

  test "should create lgl_parra_parra" do
    assert_difference("LglParraParra.count") do
      post lgl_parra_parras_url, params: { lgl_parra_parra: { child_id: @lgl_parra_parra.child_id, parent_id: @lgl_parra_parra.parent_id } }
    end

    assert_redirected_to lgl_parra_parra_url(LglParraParra.last)
  end

  test "should show lgl_parra_parra" do
    get lgl_parra_parra_url(@lgl_parra_parra)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_parra_parra_url(@lgl_parra_parra)
    assert_response :success
  end

  test "should update lgl_parra_parra" do
    patch lgl_parra_parra_url(@lgl_parra_parra), params: { lgl_parra_parra: { child_id: @lgl_parra_parra.child_id, parent_id: @lgl_parra_parra.parent_id } }
    assert_redirected_to lgl_parra_parra_url(@lgl_parra_parra)
  end

  test "should destroy lgl_parra_parra" do
    assert_difference("LglParraParra.count", -1) do
      delete lgl_parra_parra_url(@lgl_parra_parra)
    end

    assert_redirected_to lgl_parra_parras_url
  end
end
