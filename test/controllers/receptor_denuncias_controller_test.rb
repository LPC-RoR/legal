require "test_helper"

class ReceptorDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receptor_denuncia = receptor_denuncias(:one)
  end

  test "should get index" do
    get receptor_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_receptor_denuncia_url
    assert_response :success
  end

  test "should create receptor_denuncia" do
    assert_difference("ReceptorDenuncia.count") do
      post receptor_denuncias_url, params: { receptor_denuncia: { receptor_denuncia: @receptor_denuncia.receptor_denuncia } }
    end

    assert_redirected_to receptor_denuncia_url(ReceptorDenuncia.last)
  end

  test "should show receptor_denuncia" do
    get receptor_denuncia_url(@receptor_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_receptor_denuncia_url(@receptor_denuncia)
    assert_response :success
  end

  test "should update receptor_denuncia" do
    patch receptor_denuncia_url(@receptor_denuncia), params: { receptor_denuncia: { receptor_denuncia: @receptor_denuncia.receptor_denuncia } }
    assert_redirected_to receptor_denuncia_url(@receptor_denuncia)
  end

  test "should destroy receptor_denuncia" do
    assert_difference("ReceptorDenuncia.count", -1) do
      delete receptor_denuncia_url(@receptor_denuncia)
    end

    assert_redirected_to receptor_denuncias_url
  end
end
