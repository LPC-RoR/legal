require "test_helper"

class KrnModificacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_modificacion = krn_modificaciones(:one)
  end

  test "should get index" do
    get krn_modificaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_modificacion_url
    assert_response :success
  end

  test "should create krn_modificacion" do
    assert_difference("KrnModificacion.count") do
      post krn_modificaciones_url, params: { krn_modificacion: { detalle: @krn_modificacion.detalle, krn_lst_modificacion_id: @krn_modificacion.krn_lst_modificacion_id, krn_medida_id: @krn_modificacion.krn_medida_id } }
    end

    assert_redirected_to krn_modificacion_url(KrnModificacion.last)
  end

  test "should show krn_modificacion" do
    get krn_modificacion_url(@krn_modificacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_modificacion_url(@krn_modificacion)
    assert_response :success
  end

  test "should update krn_modificacion" do
    patch krn_modificacion_url(@krn_modificacion), params: { krn_modificacion: { detalle: @krn_modificacion.detalle, krn_lst_modificacion_id: @krn_modificacion.krn_lst_modificacion_id, krn_medida_id: @krn_modificacion.krn_medida_id } }
    assert_redirected_to krn_modificacion_url(@krn_modificacion)
  end

  test "should destroy krn_modificacion" do
    assert_difference("KrnModificacion.count", -1) do
      delete krn_modificacion_url(@krn_modificacion)
    end

    assert_redirected_to krn_modificaciones_url
  end
end
