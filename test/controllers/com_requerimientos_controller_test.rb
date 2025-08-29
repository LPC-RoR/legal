require "test_helper"

class ComRequerimientosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @com_requerimiento = com_requerimientos(:one)
  end

  test "should get index" do
    get com_requerimientos_url
    assert_response :success
  end

  test "should get new" do
    get new_com_requerimiento_url
    assert_response :success
  end

  test "should create com_requerimiento" do
    assert_difference("ComRequerimiento.count") do
      post com_requerimientos_url, params: { com_requerimiento: { asesoria_legal: @com_requerimiento.asesoria_legal, auditoria: @com_requerimiento.auditoria, capacitacion: @com_requerimiento.capacitacion, consultoria: @com_requerimiento.consultoria, contacto_comercial: @com_requerimiento.contacto_comercial, email: @com_requerimiento.email, externalizacion: @com_requerimiento.externalizacion, laborsafe: @com_requerimiento.laborsafe, nombre: @com_requerimiento.nombre, razon_social: @com_requerimiento.razon_social, reunion_telematica: @com_requerimiento.reunion_telematica, rut: @com_requerimiento.rut } }
    end

    assert_redirected_to com_requerimiento_url(ComRequerimiento.last)
  end

  test "should show com_requerimiento" do
    get com_requerimiento_url(@com_requerimiento)
    assert_response :success
  end

  test "should get edit" do
    get edit_com_requerimiento_url(@com_requerimiento)
    assert_response :success
  end

  test "should update com_requerimiento" do
    patch com_requerimiento_url(@com_requerimiento), params: { com_requerimiento: { asesoria_legal: @com_requerimiento.asesoria_legal, auditoria: @com_requerimiento.auditoria, capacitacion: @com_requerimiento.capacitacion, consultoria: @com_requerimiento.consultoria, contacto_comercial: @com_requerimiento.contacto_comercial, email: @com_requerimiento.email, externalizacion: @com_requerimiento.externalizacion, laborsafe: @com_requerimiento.laborsafe, nombre: @com_requerimiento.nombre, razon_social: @com_requerimiento.razon_social, reunion_telematica: @com_requerimiento.reunion_telematica, rut: @com_requerimiento.rut } }
    assert_redirected_to com_requerimiento_url(@com_requerimiento)
  end

  test "should destroy com_requerimiento" do
    assert_difference("ComRequerimiento.count", -1) do
      delete com_requerimiento_url(@com_requerimiento)
    end

    assert_redirected_to com_requerimientos_url
  end
end
