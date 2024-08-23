require "test_helper"

class KrnEmpresaExternasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @krn_empresa_externa = krn_empresa_externas(:one)
  end

  test "should get index" do
    get krn_empresa_externas_url
    assert_response :success
  end

  test "should get new" do
    get new_krn_empresa_externa_url
    assert_response :success
  end

  test "should create krn_empresa_externa" do
    assert_difference("KrnEmpresaExterna.count") do
      post krn_empresa_externas_url, params: { krn_empresa_externa: { contacto: @krn_empresa_externa.contacto, email_contacto: @krn_empresa_externa.email_contacto, razon_social: @krn_empresa_externa.razon_social, rut: @krn_empresa_externa.rut, tipo: @krn_empresa_externa.tipo } }
    end

    assert_redirected_to krn_empresa_externa_url(KrnEmpresaExterna.last)
  end

  test "should show krn_empresa_externa" do
    get krn_empresa_externa_url(@krn_empresa_externa)
    assert_response :success
  end

  test "should get edit" do
    get edit_krn_empresa_externa_url(@krn_empresa_externa)
    assert_response :success
  end

  test "should update krn_empresa_externa" do
    patch krn_empresa_externa_url(@krn_empresa_externa), params: { krn_empresa_externa: { contacto: @krn_empresa_externa.contacto, email_contacto: @krn_empresa_externa.email_contacto, razon_social: @krn_empresa_externa.razon_social, rut: @krn_empresa_externa.rut, tipo: @krn_empresa_externa.tipo } }
    assert_redirected_to krn_empresa_externa_url(@krn_empresa_externa)
  end

  test "should destroy krn_empresa_externa" do
    assert_difference("KrnEmpresaExterna.count", -1) do
      delete krn_empresa_externa_url(@krn_empresa_externa)
    end

    assert_redirected_to krn_empresa_externas_url
  end
end
