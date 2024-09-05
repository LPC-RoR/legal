require "test_helper"

class KrnMedidasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_medida = krn_medidas(:one)
  end

  test "should get index" do
    get krn_medidas_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_medida_url
    assert_response :success
  end

  test "should create krn_medida" do
    assert_difference("KrnMedida.count") do
      post krn_medidas_url, params: { krn_medida: { detalle: @krn_medida.detalle, krn_lst_medida_id: @krn_medida.krn_lst_medida_id, krn_medida: @krn_medida.krn_medida, krn_tipo_medida_id: @krn_medida.krn_tipo_medida_id } }
    end

    assert_redirected_to krn_medida_url(KrnMedida.last)
  end

  test "should show krn_medida" do
    get krn_medida_url(@krn_medida)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_medida_url(@krn_medida)
    assert_response :success
  end

  test "should update krn_medida" do
    patch krn_medida_url(@krn_medida), params: { krn_medida: { detalle: @krn_medida.detalle, krn_lst_medida_id: @krn_medida.krn_lst_medida_id, krn_medida: @krn_medida.krn_medida, krn_tipo_medida_id: @krn_medida.krn_tipo_medida_id } }
    assert_redirected_to krn_medida_url(@krn_medida)
  end

  test "should destroy krn_medida" do
    assert_difference("KrnMedida.count", -1) do
      delete krn_medida_url(@krn_medida)
    end

    assert_redirected_to krn_medidas_url
  end
end
