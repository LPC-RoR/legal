require "test_helper"

class KrnMotivoDerivacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_motivo_derivacion = krn_motivo_derivaciones(:one)
  end

  test "should get index" do
    get krn_motivo_derivaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_motivo_derivacion_url
    assert_response :success
  end

  test "should create krn_motivo_derivacion" do
    assert_difference("KrnMotivoDerivacion.count") do
      post krn_motivo_derivaciones_url, params: { krn_motivo_derivacion: { krn_motivo_derivacion: @krn_motivo_derivacion.krn_motivo_derivacion } }
    end

    assert_redirected_to krn_motivo_derivacion_url(KrnMotivoDerivacion.last)
  end

  test "should show krn_motivo_derivacion" do
    get krn_motivo_derivacion_url(@krn_motivo_derivacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_motivo_derivacion_url(@krn_motivo_derivacion)
    assert_response :success
  end

  test "should update krn_motivo_derivacion" do
    patch krn_motivo_derivacion_url(@krn_motivo_derivacion), params: { krn_motivo_derivacion: { krn_motivo_derivacion: @krn_motivo_derivacion.krn_motivo_derivacion } }
    assert_redirected_to krn_motivo_derivacion_url(@krn_motivo_derivacion)
  end

  test "should destroy krn_motivo_derivacion" do
    assert_difference("KrnMotivoDerivacion.count", -1) do
      delete krn_motivo_derivacion_url(@krn_motivo_derivacion)
    end

    assert_redirected_to krn_motivo_derivaciones_url
  end
end
