require "test_helper"

class LglTemasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_tema = lgl_temas(:one)
  end

  test "should get index" do
    get lgl_temas_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_tema_url
    assert_response :success
  end

  test "should create lgl_tema" do
    assert_difference("LglTema.count") do
      post lgl_temas_url, params: { lgl_tema: { heredado: @lgl_tema.heredado, lgl_tema: @lgl_tema.lgl_tema, orden: @lgl_tema.orden, ownr_id: @lgl_tema.ownr_id, ownr_type: @lgl_tema.ownr_type } }
    end

    assert_redirected_to lgl_tema_url(LglTema.last)
  end

  test "should show lgl_tema" do
    get lgl_tema_url(@lgl_tema)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_tema_url(@lgl_tema)
    assert_response :success
  end

  test "should update lgl_tema" do
    patch lgl_tema_url(@lgl_tema), params: { lgl_tema: { heredado: @lgl_tema.heredado, lgl_tema: @lgl_tema.lgl_tema, orden: @lgl_tema.orden, ownr_id: @lgl_tema.ownr_id, ownr_type: @lgl_tema.ownr_type } }
    assert_redirected_to lgl_tema_url(@lgl_tema)
  end

  test "should destroy lgl_tema" do
    assert_difference("LglTema.count", -1) do
      delete lgl_tema_url(@lgl_tema)
    end

    assert_redirected_to lgl_temas_url
  end
end
