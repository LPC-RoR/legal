require "test_helper"

class KrnDenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_denuncia = krn_denuncias(:one)
  end

  test "should get index" do
    get krn_denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_denuncia_url
    assert_response :success
  end

  test "should create krn_denuncia" do
    assert_difference("KrnDenuncia.count") do
      post krn_denuncias_url, params: { krn_denuncia: { cliente_id: @krn_denuncia.cliente_id, empresa_receptora_id: @krn_denuncia.empresa_receptora_id, fecha_hora: @krn_denuncia.fecha_hora, fecha_hora_dt: @krn_denuncia.fecha_hora_dt, fecha_hora_recepcion: @krn_denuncia.fecha_hora_recepcion, investigador_id: @krn_denuncia.investigador_id, motivo_denuncia_id: @krn_denuncia.motivo_denuncia_id, receptor_denuncia_id: @krn_denuncia.receptor_denuncia_id } }
    end

    assert_redirected_to krn_denuncia_url(KrnDenuncia.last)
  end

  test "should show krn_denuncia" do
    get krn_denuncia_url(@krn_denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_denuncia_url(@krn_denuncia)
    assert_response :success
  end

  test "should update krn_denuncia" do
    patch krn_denuncia_url(@krn_denuncia), params: { krn_denuncia: { cliente_id: @krn_denuncia.cliente_id, empresa_receptora_id: @krn_denuncia.empresa_receptora_id, fecha_hora: @krn_denuncia.fecha_hora, fecha_hora_dt: @krn_denuncia.fecha_hora_dt, fecha_hora_recepcion: @krn_denuncia.fecha_hora_recepcion, investigador_id: @krn_denuncia.investigador_id, motivo_denuncia_id: @krn_denuncia.motivo_denuncia_id, receptor_denuncia_id: @krn_denuncia.receptor_denuncia_id } }
    assert_redirected_to krn_denuncia_url(@krn_denuncia)
  end

  test "should destroy krn_denuncia" do
    assert_difference("KrnDenuncia.count", -1) do
      delete krn_denuncia_url(@krn_denuncia)
    end

    assert_redirected_to krn_denuncias_url
  end
end
