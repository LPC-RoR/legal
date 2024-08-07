require "test_helper"

class MotivoDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @motivo_denuncia = motivo_denuncias(:one)
  end

  test "should get index" do
    get motivo_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_motivo_denuncia_url
    assert_response :success
  end

  test "should create motivo_denuncia" do
    assert_difference("MotivoDenuncia.count") do
      post motivo_denuncias_url, params: { motivo_denuncia: { motivo_denuncia: @motivo_denuncia.motivo_denuncia } }
    end

    assert_redirected_to motivo_denuncia_url(MotivoDenuncia.last)
  end

  test "should show motivo_denuncia" do
    get motivo_denuncia_url(@motivo_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_motivo_denuncia_url(@motivo_denuncia)
    assert_response :success
  end

  test "should update motivo_denuncia" do
    patch motivo_denuncia_url(@motivo_denuncia), params: { motivo_denuncia: { motivo_denuncia: @motivo_denuncia.motivo_denuncia } }
    assert_redirected_to motivo_denuncia_url(@motivo_denuncia)
  end

  test "should destroy motivo_denuncia" do
    assert_difference("MotivoDenuncia.count", -1) do
      delete motivo_denuncia_url(@motivo_denuncia)
    end

    assert_redirected_to motivo_denuncias_url
  end
end
