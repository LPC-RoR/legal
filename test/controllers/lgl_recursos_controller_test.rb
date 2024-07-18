require "test_helper"

class LglRecursosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_recurso = lgl_recursos(:one)
  end

  test "should get index" do
    get lgl_recursos_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_recurso_url
    assert_response :success
  end

  test "should create lgl_recurso" do
    assert_difference("LglRecurso.count") do
      post lgl_recursos_url, params: { lgl_recurso: { lgl_recurso: @lgl_recurso.lgl_recurso, tipo: @lgl_recurso.tipo } }
    end

    assert_redirected_to lgl_recurso_url(LglRecurso.last)
  end

  test "should show lgl_recurso" do
    get lgl_recurso_url(@lgl_recurso)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_recurso_url(@lgl_recurso)
    assert_response :success
  end

  test "should update lgl_recurso" do
    patch lgl_recurso_url(@lgl_recurso), params: { lgl_recurso: { lgl_recurso: @lgl_recurso.lgl_recurso, tipo: @lgl_recurso.tipo } }
    assert_redirected_to lgl_recurso_url(@lgl_recurso)
  end

  test "should destroy lgl_recurso" do
    assert_difference("LglRecurso.count", -1) do
      delete lgl_recurso_url(@lgl_recurso)
    end

    assert_redirected_to lgl_recursos_url
  end
end
