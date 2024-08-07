require "test_helper"

class AlcanceDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alcance_denuncia = alcance_denuncias(:one)
  end

  test "should get index" do
    get alcance_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_alcance_denuncia_url
    assert_response :success
  end

  test "should create alcance_denuncia" do
    assert_difference("AlcanceDenuncia.count") do
      post alcance_denuncias_url, params: { alcance_denuncia: { alcance_denuncia: @alcance_denuncia.alcance_denuncia } }
    end

    assert_redirected_to alcance_denuncia_url(AlcanceDenuncia.last)
  end

  test "should show alcance_denuncia" do
    get alcance_denuncia_url(@alcance_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_alcance_denuncia_url(@alcance_denuncia)
    assert_response :success
  end

  test "should update alcance_denuncia" do
    patch alcance_denuncia_url(@alcance_denuncia), params: { alcance_denuncia: { alcance_denuncia: @alcance_denuncia.alcance_denuncia } }
    assert_redirected_to alcance_denuncia_url(@alcance_denuncia)
  end

  test "should destroy alcance_denuncia" do
    assert_difference("AlcanceDenuncia.count", -1) do
      delete alcance_denuncia_url(@alcance_denuncia)
    end

    assert_redirected_to alcance_denuncias_url
  end
end
