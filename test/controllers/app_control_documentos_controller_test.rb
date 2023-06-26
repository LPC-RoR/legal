require 'test_helper'

class AppControlDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_control_documento = app_control_documentos(:one)
  end

  test "should get index" do
    get app_control_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_control_documento_url
    assert_response :success
  end

  test "should create app_control_documento" do
    assert_difference('AppControlDocumento.count') do
      post app_control_documentos_url, params: { app_control_documento: { app_control_documento: @app_control_documento.app_control_documento, existencia: @app_control_documento.existencia, owner_id: @app_control_documento.owner_id, ownr_class: @app_control_documento.ownr_class, vencimiento: @app_control_documento.vencimiento } }
    end

    assert_redirected_to app_control_documento_url(AppControlDocumento.last)
  end

  test "should show app_control_documento" do
    get app_control_documento_url(@app_control_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_control_documento_url(@app_control_documento)
    assert_response :success
  end

  test "should update app_control_documento" do
    patch app_control_documento_url(@app_control_documento), params: { app_control_documento: { app_control_documento: @app_control_documento.app_control_documento, existencia: @app_control_documento.existencia, owner_id: @app_control_documento.owner_id, ownr_class: @app_control_documento.ownr_class, vencimiento: @app_control_documento.vencimiento } }
    assert_redirected_to app_control_documento_url(@app_control_documento)
  end

  test "should destroy app_control_documento" do
    assert_difference('AppControlDocumento.count', -1) do
      delete app_control_documento_url(@app_control_documento)
    end

    assert_redirected_to app_control_documentos_url
  end
end
