require "test_helper"

class DenunciadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @denunciado = denunciados(:one)
  end

  test "should get index" do
    get denunciados_url
    assert_response :success
  end

  test "should get new" do
    get new_denunciado_url
    assert_response :success
  end

  test "should create denunciado" do
    assert_difference("Denunciado.count") do
      post denunciados_url, params: { denunciado: { cargo: @denunciado.cargo, denuncia_id: @denunciado.denuncia_id, denunciado: @denunciado.denunciado, email: @denunciado.email, lugar_trabajo: @denunciado.lugar_trabajo, rut: @denunciado.rut, tipo_denunciado_id: @denunciado.tipo_denunciado_id, vinculo: @denunciado.vinculo } }
    end

    assert_redirected_to denunciado_url(Denunciado.last)
  end

  test "should show denunciado" do
    get denunciado_url(@denunciado)
    assert_response :success
  end

  test "should get edit" do
    get edit_denunciado_url(@denunciado)
    assert_response :success
  end

  test "should update denunciado" do
    patch denunciado_url(@denunciado), params: { denunciado: { cargo: @denunciado.cargo, denuncia_id: @denunciado.denuncia_id, denunciado: @denunciado.denunciado, email: @denunciado.email, lugar_trabajo: @denunciado.lugar_trabajo, rut: @denunciado.rut, tipo_denunciado_id: @denunciado.tipo_denunciado_id, vinculo: @denunciado.vinculo } }
    assert_redirected_to denunciado_url(@denunciado)
  end

  test "should destroy denunciado" do
    assert_difference("Denunciado.count", -1) do
      delete denunciado_url(@denunciado)
    end

    assert_redirected_to denunciados_url
  end
end
