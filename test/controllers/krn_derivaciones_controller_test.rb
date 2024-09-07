require "test_helper"

class KrnDerivacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_derivacion = krn_derivaciones(:one)
  end

  test "should get index" do
    get krn_derivaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_derivacion_url
    assert_response :success
  end

  test "should create krn_derivacion" do
    assert_difference("KrnDerivacion.count") do
      post krn_derivaciones_url, params: { krn_derivacion: { fecha: @krn_derivacion.fecha, krn_denuncia_id: @krn_derivacion.krn_denuncia_id, krn_empresa_externa_id: @krn_derivacion.krn_empresa_externa_id, krn_motivo_denuncia_id: @krn_derivacion.krn_motivo_denuncia_id, otro_motivo: @krn_derivacion.otro_motivo } }
    end

    assert_redirected_to krn_derivacion_url(KrnDerivacion.last)
  end

  test "should show krn_derivacion" do
    get krn_derivacion_url(@krn_derivacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_derivacion_url(@krn_derivacion)
    assert_response :success
  end

  test "should update krn_derivacion" do
    patch krn_derivacion_url(@krn_derivacion), params: { krn_derivacion: { fecha: @krn_derivacion.fecha, krn_denuncia_id: @krn_derivacion.krn_denuncia_id, krn_empresa_externa_id: @krn_derivacion.krn_empresa_externa_id, krn_motivo_denuncia_id: @krn_derivacion.krn_motivo_denuncia_id, otro_motivo: @krn_derivacion.otro_motivo } }
    assert_redirected_to krn_derivacion_url(@krn_derivacion)
  end

  test "should destroy krn_derivacion" do
    assert_difference("KrnDerivacion.count", -1) do
      delete krn_derivacion_url(@krn_derivacion)
    end

    assert_redirected_to krn_derivaciones_url
  end
end
