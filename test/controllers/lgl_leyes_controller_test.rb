require "test_helper"

class LglLeyesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_ley = lgl_leyes(:one)
  end

  test "should get index" do
    get lgl_leyes_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_ley_url
    assert_response :success
  end

  test "should create lgl_ley" do
    assert_difference("LglLey.count") do
      post lgl_leyes_url, params: { lgl_ley: { cdg: @lgl_ley.cdg, lgl_repositorio_id: @lgl_ley.lgl_repositorio_id, nombre: @lgl_ley.nombre } }
    end

    assert_redirected_to lgl_ley_url(LglLey.last)
  end

  test "should show lgl_ley" do
    get lgl_ley_url(@lgl_ley)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_ley_url(@lgl_ley)
    assert_response :success
  end

  test "should update lgl_ley" do
    patch lgl_ley_url(@lgl_ley), params: { lgl_ley: { cdg: @lgl_ley.cdg, lgl_repositorio_id: @lgl_ley.lgl_repositorio_id, nombre: @lgl_ley.nombre } }
    assert_redirected_to lgl_ley_url(@lgl_ley)
  end

  test "should destroy lgl_ley" do
    assert_difference("LglLey.count", -1) do
      delete lgl_ley_url(@lgl_ley)
    end

    assert_redirected_to lgl_leyes_url
  end
end
