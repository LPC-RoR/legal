require "test_helper"

class LglRepositoriosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_repositorio = lgl_repositorios(:one)
  end

  test "should get index" do
    get lgl_repositorios_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_repositorio_url
    assert_response :success
  end

  test "should create lgl_repositorio" do
    assert_difference("LglRepositorio.count") do
      post lgl_repositorios_url, params: { lgl_repositorio: { dcg: @lgl_repositorio.dcg, nombre: @lgl_repositorio.nombre } }
    end

    assert_redirected_to lgl_repositorio_url(LglRepositorio.last)
  end

  test "should show lgl_repositorio" do
    get lgl_repositorio_url(@lgl_repositorio)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_repositorio_url(@lgl_repositorio)
    assert_response :success
  end

  test "should update lgl_repositorio" do
    patch lgl_repositorio_url(@lgl_repositorio), params: { lgl_repositorio: { dcg: @lgl_repositorio.dcg, nombre: @lgl_repositorio.nombre } }
    assert_redirected_to lgl_repositorio_url(@lgl_repositorio)
  end

  test "should destroy lgl_repositorio" do
    assert_difference("LglRepositorio.count", -1) do
      delete lgl_repositorio_url(@lgl_repositorio)
    end

    assert_redirected_to lgl_repositorios_url
  end
end
