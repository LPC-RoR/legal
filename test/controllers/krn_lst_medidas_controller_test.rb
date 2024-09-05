require "test_helper"

class KrnLstMedidasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_lst_medida = krn_lst_medidas(:one)
  end

  test "should get index" do
    get krn_lst_medidas_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_lst_medida_url
    assert_response :success
  end

  test "should create krn_lst_medida" do
    assert_difference("KrnLstMedida.count") do
      post krn_lst_medidas_url, params: { krn_lst_medida: { emisor: @krn_lst_medida.emisor, ownr_id: @krn_lst_medida.ownr_id, ownr_type: @krn_lst_medida.ownr_type, tipo: @krn_lst_medida.tipo } }
    end

    assert_redirected_to krn_lst_medida_url(KrnLstMedida.last)
  end

  test "should show krn_lst_medida" do
    get krn_lst_medida_url(@krn_lst_medida)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_lst_medida_url(@krn_lst_medida)
    assert_response :success
  end

  test "should update krn_lst_medida" do
    patch krn_lst_medida_url(@krn_lst_medida), params: { krn_lst_medida: { emisor: @krn_lst_medida.emisor, ownr_id: @krn_lst_medida.ownr_id, ownr_type: @krn_lst_medida.ownr_type, tipo: @krn_lst_medida.tipo } }
    assert_redirected_to krn_lst_medida_url(@krn_lst_medida)
  end

  test "should destroy krn_lst_medida" do
    assert_difference("KrnLstMedida.count", -1) do
      delete krn_lst_medida_url(@krn_lst_medida)
    end

    assert_redirected_to krn_lst_medidas_url
  end
end
