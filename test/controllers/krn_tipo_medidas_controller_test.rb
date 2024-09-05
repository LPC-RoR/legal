require "test_helper"

class KrnTipoMedidasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_tipo_medida = krn_tipo_medidas(:one)
  end

  test "should get index" do
    get krn_tipo_medidas_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_tipo_medida_url
    assert_response :success
  end

  test "should create krn_tipo_medida" do
    assert_difference("KrnTipoMedida.count") do
      post krn_tipo_medidas_url, params: { krn_tipo_medida: { cliente_id: @krn_tipo_medida.cliente_id, denunciado: @krn_tipo_medida.denunciado, denunciante: @krn_tipo_medida.denunciante, empresa_id: @krn_tipo_medida.empresa_id, krn_tipo_medida: @krn_tipo_medida.krn_tipo_medida, tipo: @krn_tipo_medida.tipo } }
    end

    assert_redirected_to krn_tipo_medida_url(KrnTipoMedida.last)
  end

  test "should show krn_tipo_medida" do
    get krn_tipo_medida_url(@krn_tipo_medida)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_tipo_medida_url(@krn_tipo_medida)
    assert_response :success
  end

  test "should update krn_tipo_medida" do
    patch krn_tipo_medida_url(@krn_tipo_medida), params: { krn_tipo_medida: { cliente_id: @krn_tipo_medida.cliente_id, denunciado: @krn_tipo_medida.denunciado, denunciante: @krn_tipo_medida.denunciante, empresa_id: @krn_tipo_medida.empresa_id, krn_tipo_medida: @krn_tipo_medida.krn_tipo_medida, tipo: @krn_tipo_medida.tipo } }
    assert_redirected_to krn_tipo_medida_url(@krn_tipo_medida)
  end

  test "should destroy krn_tipo_medida" do
    assert_difference("KrnTipoMedida.count", -1) do
      delete krn_tipo_medida_url(@krn_tipo_medida)
    end

    assert_redirected_to krn_tipo_medidas_url
  end
end
