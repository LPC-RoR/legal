require "test_helper"

class KrnInvDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_inv_denuncia = krn_inv_denuncias(:one)
  end

  test "should get index" do
    get krn_inv_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_inv_denuncia_url
    assert_response :success
  end

  test "should create krn_inv_denuncia" do
    assert_difference("KrnInvDenuncia.count") do
      post krn_inv_denuncias_url, params: { krn_inv_denuncia: { krn_denuncia_id: @krn_inv_denuncia.krn_denuncia_id, krn_investigador_id: @krn_inv_denuncia.krn_investigador_id } }
    end

    assert_redirected_to krn_inv_denuncia_url(KrnInvDenuncia.last)
  end

  test "should show krn_inv_denuncia" do
    get krn_inv_denuncia_url(@krn_inv_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_inv_denuncia_url(@krn_inv_denuncia)
    assert_response :success
  end

  test "should update krn_inv_denuncia" do
    patch krn_inv_denuncia_url(@krn_inv_denuncia), params: { krn_inv_denuncia: { krn_denuncia_id: @krn_inv_denuncia.krn_denuncia_id, krn_investigador_id: @krn_inv_denuncia.krn_investigador_id } }
    assert_redirected_to krn_inv_denuncia_url(@krn_inv_denuncia)
  end

  test "should destroy krn_inv_denuncia" do
    assert_difference("KrnInvDenuncia.count", -1) do
      delete krn_inv_denuncia_url(@krn_inv_denuncia)
    end

    assert_redirected_to krn_inv_denuncias_url
  end
end
