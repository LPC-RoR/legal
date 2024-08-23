require "test_helper"

class KrnDenunciantesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_denunciante = krn_denunciantes(:one)
  end

  test "should get index" do
    get krn_denunciantes_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_denunciante_url
    assert_response :success
  end

  test "should create krn_denunciante" do
    assert_difference("KrnDenunciante.count") do
      post krn_denunciantes_url, params: { krn_denunciante: { articulo_4_1: @krn_denunciante.articulo_4_1, cargo: @krn_denunciante.cargo, denuncia_id: @krn_denunciante.denuncia_id, email: @krn_denunciante.email, email_ok: @krn_denunciante.email_ok, empresa_externa_id: @krn_denunciante.empresa_externa_id, lugar_trabajo: @krn_denunciante.lugar_trabajo, nombre: @krn_denunciante.nombre, rut: @krn_denunciante.rut } }
    end

    assert_redirected_to krn_denunciante_url(KrnDenunciante.last)
  end

  test "should show krn_denunciante" do
    get krn_denunciante_url(@krn_denunciante)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_denunciante_url(@krn_denunciante)
    assert_response :success
  end

  test "should update krn_denunciante" do
    patch krn_denunciante_url(@krn_denunciante), params: { krn_denunciante: { articulo_4_1: @krn_denunciante.articulo_4_1, cargo: @krn_denunciante.cargo, denuncia_id: @krn_denunciante.denuncia_id, email: @krn_denunciante.email, email_ok: @krn_denunciante.email_ok, empresa_externa_id: @krn_denunciante.empresa_externa_id, lugar_trabajo: @krn_denunciante.lugar_trabajo, nombre: @krn_denunciante.nombre, rut: @krn_denunciante.rut } }
    assert_redirected_to krn_denunciante_url(@krn_denunciante)
  end

  test "should destroy krn_denunciante" do
    assert_difference("KrnDenunciante.count", -1) do
      delete krn_denunciante_url(@krn_denunciante)
    end

    assert_redirected_to krn_denunciantes_url
  end
end
