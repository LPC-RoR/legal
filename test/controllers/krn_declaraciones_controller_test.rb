require "test_helper"

class KrnDeclaracionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_declaracion = krn_declaraciones(:one)
  end

  test "should get index" do
    get krn_declaraciones_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_declaracion_url
    assert_response :success
  end

  test "should create krn_declaracion" do
    assert_difference("KrnDeclaracion.count") do
      post krn_declaraciones_url, params: { krn_declaracion: { archivo: @krn_declaracion.archivo, fecha: @krn_declaracion.fecha, krn_denuncia_id: @krn_declaracion.krn_denuncia_id, ownr_id: @krn_declaracion.ownr_id, ownr_type: @krn_declaracion.ownr_type } }
    end

    assert_redirected_to krn_declaracion_url(KrnDeclaracion.last)
  end

  test "should show krn_declaracion" do
    get krn_declaracion_url(@krn_declaracion)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_declaracion_url(@krn_declaracion)
    assert_response :success
  end

  test "should update krn_declaracion" do
    patch krn_declaracion_url(@krn_declaracion), params: { krn_declaracion: { archivo: @krn_declaracion.archivo, fecha: @krn_declaracion.fecha, krn_denuncia_id: @krn_declaracion.krn_denuncia_id, ownr_id: @krn_declaracion.ownr_id, ownr_type: @krn_declaracion.ownr_type } }
    assert_redirected_to krn_declaracion_url(@krn_declaracion)
  end

  test "should destroy krn_declaracion" do
    assert_difference("KrnDeclaracion.count", -1) do
      delete krn_declaracion_url(@krn_declaracion)
    end

    assert_redirected_to krn_declaraciones_url
  end
end
