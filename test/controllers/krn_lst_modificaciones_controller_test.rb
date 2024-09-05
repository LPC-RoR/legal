require "test_helper"

class KrnLstModificacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_lst_modificacion = krn_lst_modificaciones(:one)
  end

  test "should get index" do
    get krn_lst_modificaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_lst_modificacion_url
    assert_response :success
  end

  test "should create krn_lst_modificacion" do
    assert_difference("KrnLstModificacion.count") do
      post krn_lst_modificaciones_url, params: { krn_lst_modificacion: { emisor: @krn_lst_modificacion.emisor, ownr_id: @krn_lst_modificacion.ownr_id, ownr_type: @krn_lst_modificacion.ownr_type } }
    end

    assert_redirected_to krn_lst_modificacion_url(KrnLstModificacion.last)
  end

  test "should show krn_lst_modificacion" do
    get krn_lst_modificacion_url(@krn_lst_modificacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_lst_modificacion_url(@krn_lst_modificacion)
    assert_response :success
  end

  test "should update krn_lst_modificacion" do
    patch krn_lst_modificacion_url(@krn_lst_modificacion), params: { krn_lst_modificacion: { emisor: @krn_lst_modificacion.emisor, ownr_id: @krn_lst_modificacion.ownr_id, ownr_type: @krn_lst_modificacion.ownr_type } }
    assert_redirected_to krn_lst_modificacion_url(@krn_lst_modificacion)
  end

  test "should destroy krn_lst_modificacion" do
    assert_difference("KrnLstModificacion.count", -1) do
      delete krn_lst_modificacion_url(@krn_lst_modificacion)
    end

    assert_redirected_to krn_lst_modificaciones_url
  end
end
