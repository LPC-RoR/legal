require 'test_helper'

class AppDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_documento = app_documentos(:one)
  end

  test "should get index" do
    get app_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_documento_url
    assert_response :success
  end

  test "should create app_documento" do
    assert_difference('AppDocumento.count') do
      post app_documentos_url, params: { app_documento: { app_directorio_id: @app_documento.app_directorio_id, documento: @app_documento.documento, publico: @app_documento.publico } }
    end

    assert_redirected_to app_documento_url(AppDocumento.last)
  end

  test "should show app_documento" do
    get app_documento_url(@app_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_documento_url(@app_documento)
    assert_response :success
  end

  test "should update app_documento" do
    patch app_documento_url(@app_documento), params: { app_documento: { app_directorio_id: @app_documento.app_directorio_id, documento: @app_documento.documento, publico: @app_documento.publico } }
    assert_redirected_to app_documento_url(@app_documento)
  end

  test "should destroy app_documento" do
    assert_difference('AppDocumento.count', -1) do
      delete app_documento_url(@app_documento)
    end

    assert_redirected_to app_documentos_url
  end
end
