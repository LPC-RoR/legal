require "test_helper"

class KrnTestigosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_testigo = krn_testigos(:one)
  end

  test "should get index" do
    get krn_testigos_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_testigo_url
    assert_response :success
  end

  test "should create krn_testigo" do
    assert_difference("KrnTestigo.count") do
      post krn_testigos_url, params: { krn_testigo: { cargo: @krn_testigo.cargo, email: @krn_testigo.email, email_ok: @krn_testigo.email_ok, info_derechos: @krn_testigo.info_derechos, info_procedimiento: @krn_testigo.info_procedimiento, info_reglamento: @krn_testigo.info_reglamento, krn_empresa_externa_id: @krn_testigo.krn_empresa_externa_id, lugar_trabajo: @krn_testigo.lugar_trabajo, nombre: @krn_testigo.nombre, ownr_id: @krn_testigo.ownr_id, ownr_type: @krn_testigo.ownr_type, rut: @krn_testigo.rut } }
    end

    assert_redirected_to krn_testigo_url(KrnTestigo.last)
  end

  test "should show krn_testigo" do
    get krn_testigo_url(@krn_testigo)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_testigo_url(@krn_testigo)
    assert_response :success
  end

  test "should update krn_testigo" do
    patch krn_testigo_url(@krn_testigo), params: { krn_testigo: { cargo: @krn_testigo.cargo, email: @krn_testigo.email, email_ok: @krn_testigo.email_ok, info_derechos: @krn_testigo.info_derechos, info_procedimiento: @krn_testigo.info_procedimiento, info_reglamento: @krn_testigo.info_reglamento, krn_empresa_externa_id: @krn_testigo.krn_empresa_externa_id, lugar_trabajo: @krn_testigo.lugar_trabajo, nombre: @krn_testigo.nombre, ownr_id: @krn_testigo.ownr_id, ownr_type: @krn_testigo.ownr_type, rut: @krn_testigo.rut } }
    assert_redirected_to krn_testigo_url(@krn_testigo)
  end

  test "should destroy krn_testigo" do
    assert_difference("KrnTestigo.count", -1) do
      delete krn_testigo_url(@krn_testigo)
    end

    assert_redirected_to krn_testigos_url
  end
end
