require "test_helper"

class LglDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lgl_documento = lgl_documentos(:one)
  end

  test "should get index" do
    get lgl_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_lgl_documento_url
    assert_response :success
  end

  test "should create lgl_documento" do
    assert_difference("LglDocumento.count") do
      post lgl_documentos_url, params: { lgl_documento: { lgl_documento: @lgl_documento.lgl_documento, tipo: @lgl_documento.tipo } }
    end

    assert_redirected_to lgl_documento_url(LglDocumento.last)
  end

  test "should show lgl_documento" do
    get lgl_documento_url(@lgl_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_lgl_documento_url(@lgl_documento)
    assert_response :success
  end

  test "should update lgl_documento" do
    patch lgl_documento_url(@lgl_documento), params: { lgl_documento: { lgl_documento: @lgl_documento.lgl_documento, tipo: @lgl_documento.tipo } }
    assert_redirected_to lgl_documento_url(@lgl_documento)
  end

  test "should destroy lgl_documento" do
    assert_difference("LglDocumento.count", -1) do
      delete lgl_documento_url(@lgl_documento)
    end

    assert_redirected_to lgl_documentos_url
  end
end
