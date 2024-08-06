require "test_helper"

class DenunciasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @denuncia = denuncias(:one)
  end

  test "should get index" do
    get denuncias_url
    assert_response :success
  end

  test "should get new" do
    get new_denuncia_url
    assert_response :success
  end

  test "should create denuncia" do
    assert_difference("Denuncia.count") do
      post denuncias_url, params: { denuncia: { cargo: @denuncia.cargo, denunciante: @denuncia.denunciante, email: @denuncia.email, empleador_dt_tercero: @denuncia.empleador_dt_tercero, empresa_id: @denuncia.empresa_id, lugar_trabajo: @denuncia.lugar_trabajo, presencial_electronica: @denuncia.presencial_electronica, rut: @denuncia.rut, tipo_denuncia_id: @denuncia.tipo_denuncia_id, verbal_escrita: @denuncia.verbal_escrita } }
    end

    assert_redirected_to denuncia_url(Denuncia.last)
  end

  test "should show denuncia" do
    get denuncia_url(@denuncia)
    assert_response :success
  end

  test "should get edit" do
    get edit_denuncia_url(@denuncia)
    assert_response :success
  end

  test "should update denuncia" do
    patch denuncia_url(@denuncia), params: { denuncia: { cargo: @denuncia.cargo, denunciante: @denuncia.denunciante, email: @denuncia.email, empleador_dt_tercero: @denuncia.empleador_dt_tercero, empresa_id: @denuncia.empresa_id, lugar_trabajo: @denuncia.lugar_trabajo, presencial_electronica: @denuncia.presencial_electronica, rut: @denuncia.rut, tipo_denuncia_id: @denuncia.tipo_denuncia_id, verbal_escrita: @denuncia.verbal_escrita } }
    assert_redirected_to denuncia_url(@denuncia)
  end

  test "should destroy denuncia" do
    assert_difference("Denuncia.count", -1) do
      delete denuncia_url(@denuncia)
    end

    assert_redirected_to denuncias_url
  end
end
