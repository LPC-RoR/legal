require "test_helper"

class KrnTramitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_tramite = krn_tramites(:one)
  end

  test "should get index" do
    get krn_tramites_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_tramite_url
    assert_response :success
  end

  test "should create krn_tramite" do
    assert_difference("KrnTramite.count") do
      post krn_tramites_url, params: { krn_tramite: { fecha_hora: @krn_tramite.fecha_hora, krn_denuncia_id: @krn_tramite.krn_denuncia_id, numero_solicitutud: @krn_tramite.numero_solicitutud, tipo: @krn_tramite.tipo } }
    end

    assert_redirected_to krn_tramite_url(KrnTramite.last)
  end

  test "should show krn_tramite" do
    get krn_tramite_url(@krn_tramite)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_tramite_url(@krn_tramite)
    assert_response :success
  end

  test "should update krn_tramite" do
    patch krn_tramite_url(@krn_tramite), params: { krn_tramite: { fecha_hora: @krn_tramite.fecha_hora, krn_denuncia_id: @krn_tramite.krn_denuncia_id, numero_solicitutud: @krn_tramite.numero_solicitutud, tipo: @krn_tramite.tipo } }
    assert_redirected_to krn_tramite_url(@krn_tramite)
  end

  test "should destroy krn_tramite" do
    assert_difference("KrnTramite.count", -1) do
      delete krn_tramite_url(@krn_tramite)
    end

    assert_redirected_to krn_tramites_url
  end
end
