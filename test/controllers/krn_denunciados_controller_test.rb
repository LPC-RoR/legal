require "test_helper"

class KrnDenunciadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_denunciado = krn_denunciados(:one)
  end

  test "should get index" do
    get krn_denunciados_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_denunciado_url
    assert_response :success
  end

  test "should create krn_denunciado" do
    assert_difference("KrnDenunciado.count") do
      post krn_denunciados_url, params: { krn_denunciado: { articulo_4_1: @krn_denunciado.articulo_4_1, cargo: @krn_denunciado.cargo, denuncia_id: @krn_denunciado.denuncia_id, email: @krn_denunciado.email, email_ok: @krn_denunciado.email_ok, empresa_externa_id: @krn_denunciado.empresa_externa_id, lugar_trabajo: @krn_denunciado.lugar_trabajo, nombre: @krn_denunciado.nombre, rut: @krn_denunciado.rut } }
    end

    assert_redirected_to krn_denunciado_url(KrnDenunciado.last)
  end

  test "should show krn_denunciado" do
    get krn_denunciado_url(@krn_denunciado)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_denunciado_url(@krn_denunciado)
    assert_response :success
  end

  test "should update krn_denunciado" do
    patch krn_denunciado_url(@krn_denunciado), params: { krn_denunciado: { articulo_4_1: @krn_denunciado.articulo_4_1, cargo: @krn_denunciado.cargo, denuncia_id: @krn_denunciado.denuncia_id, email: @krn_denunciado.email, email_ok: @krn_denunciado.email_ok, empresa_externa_id: @krn_denunciado.empresa_externa_id, lugar_trabajo: @krn_denunciado.lugar_trabajo, nombre: @krn_denunciado.nombre, rut: @krn_denunciado.rut } }
    assert_redirected_to krn_denunciado_url(@krn_denunciado)
  end

  test "should destroy krn_denunciado" do
    assert_difference("KrnDenunciado.count", -1) do
      delete krn_denunciado_url(@krn_denunciado)
    end

    assert_redirected_to krn_denunciados_url
  end
end
