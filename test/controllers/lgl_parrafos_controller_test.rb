require "test_helper"

class LglParrafosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_parrafo = lgl_parrafos(:one)
  end

  test "should get index" do
    get lgl_parrafos_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_parrafo_url
    assert_response :success
  end

  test "should create lgl_parrafo" do
    assert_difference("LglParrafo.count") do
      post lgl_parrafos_url, params: { lgl_parrafo: { lgl_documento_id: @lgl_parrafo.lgl_documento_id, lgl_parrafo: @lgl_parrafo.lgl_parrafo, orden: @lgl_parrafo.orden, tipo: @lgl_parrafo.tipo } }
    end

    assert_redirected_to lgl_parrafo_url(LglParrafo.last)
  end

  test "should show lgl_parrafo" do
    get lgl_parrafo_url(@lgl_parrafo)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_parrafo_url(@lgl_parrafo)
    assert_response :success
  end

  test "should update lgl_parrafo" do
    patch lgl_parrafo_url(@lgl_parrafo), params: { lgl_parrafo: { lgl_documento_id: @lgl_parrafo.lgl_documento_id, lgl_parrafo: @lgl_parrafo.lgl_parrafo, orden: @lgl_parrafo.orden, tipo: @lgl_parrafo.tipo } }
    assert_redirected_to lgl_parrafo_url(@lgl_parrafo)
  end

  test "should destroy lgl_parrafo" do
    assert_difference("LglParrafo.count", -1) do
      delete lgl_parrafo_url(@lgl_parrafo)
    end

    assert_redirected_to lgl_parrafos_url
  end
end
