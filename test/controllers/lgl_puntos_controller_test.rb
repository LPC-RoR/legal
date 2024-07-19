require "test_helper"

class LglPuntosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_punto = lgl_puntos(:one)
  end

  test "should get index" do
    get lgl_puntos_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_punto_url
    assert_response :success
  end

  test "should create lgl_punto" do
    assert_difference("LglPunto.count") do
      post lgl_puntos_url, params: { lgl_punto: { cita: @lgl_punto.cita, lgl_parrafo_id: @lgl_punto.lgl_parrafo_id, lgl_punto: @lgl_punto.lgl_punto, orden: @lgl_punto.orden } }
    end

    assert_redirected_to lgl_punto_url(LglPunto.last)
  end

  test "should show lgl_punto" do
    get lgl_punto_url(@lgl_punto)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_punto_url(@lgl_punto)
    assert_response :success
  end

  test "should update lgl_punto" do
    patch lgl_punto_url(@lgl_punto), params: { lgl_punto: { cita: @lgl_punto.cita, lgl_parrafo_id: @lgl_punto.lgl_parrafo_id, lgl_punto: @lgl_punto.lgl_punto, orden: @lgl_punto.orden } }
    assert_redirected_to lgl_punto_url(@lgl_punto)
  end

  test "should destroy lgl_punto" do
    assert_difference("LglPunto.count", -1) do
      delete lgl_punto_url(@lgl_punto)
    end

    assert_redirected_to lgl_puntos_url
  end
end
