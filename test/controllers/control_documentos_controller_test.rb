require 'test_helper'

class ControlDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @control_documento = control_documentos(:one)
  end

  test "should get index" do
    get control_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_control_documento_url
    assert_response :success
  end

  test "should create control_documento" do
    assert_difference('ControlDocumento.count') do
      post control_documentos_url, params: { control_documento: { control: @control_documento.control, descripcion: @control_documento.descripcion, nombre: @control_documento.nombre, tipo: @control_documento.tipo } }
    end

    assert_redirected_to control_documento_url(ControlDocumento.last)
  end

  test "should show control_documento" do
    get control_documento_url(@control_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_control_documento_url(@control_documento)
    assert_response :success
  end

  test "should update control_documento" do
    patch control_documento_url(@control_documento), params: { control_documento: { control: @control_documento.control, descripcion: @control_documento.descripcion, nombre: @control_documento.nombre, tipo: @control_documento.tipo } }
    assert_redirected_to control_documento_url(@control_documento)
  end

  test "should destroy control_documento" do
    assert_difference('ControlDocumento.count', -1) do
      delete control_documento_url(@control_documento)
    end

    assert_redirected_to control_documentos_url
  end
end
