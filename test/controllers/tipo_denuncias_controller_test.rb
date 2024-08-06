require "test_helper"

class TipoDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_denuncia = tipo_denuncias(:one)
  end

  test "should get index" do
    get tipo_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_denuncia_url
    assert_response :success
  end

  test "should create tipo_denuncia" do
    assert_difference("TipoDenuncia.count") do
      post tipo_denuncias_url, params: { tipo_denuncia: { tipo_denuncia: @tipo_denuncia.tipo_denuncia } }
    end

    assert_redirected_to tipo_denuncia_url(TipoDenuncia.last)
  end

  test "should show tipo_denuncia" do
    get tipo_denuncia_url(@tipo_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_denuncia_url(@tipo_denuncia)
    assert_response :success
  end

  test "should update tipo_denuncia" do
    patch tipo_denuncia_url(@tipo_denuncia), params: { tipo_denuncia: { tipo_denuncia: @tipo_denuncia.tipo_denuncia } }
    assert_redirected_to tipo_denuncia_url(@tipo_denuncia)
  end

  test "should destroy tipo_denuncia" do
    assert_difference("TipoDenuncia.count", -1) do
      delete tipo_denuncia_url(@tipo_denuncia)
    end

    assert_redirected_to tipo_denuncias_url
  end
end
