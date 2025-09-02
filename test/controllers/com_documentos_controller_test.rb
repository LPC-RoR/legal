require "test_helper"

class ComDocumentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @com_documento = com_documentos(:one)
  end

  test "should get index" do
    get com_documentos_url
    assert_response :success
  end

  test "should get new" do
    get new_com_documento_url
    assert_response :success
  end

  test "should create com_documento" do
    assert_difference("ComDocumento.count") do
      post com_documentos_url, params: { com_documento: { doc_type: @com_documento.doc_type, issued_on: @com_documento.issued_on, titulo: @com_documento.titulo } }
    end

    assert_redirected_to com_documento_url(ComDocumento.last)
  end

  test "should show com_documento" do
    get com_documento_url(@com_documento)
    assert_response :success
  end

  test "should get edit" do
    get edit_com_documento_url(@com_documento)
    assert_response :success
  end

  test "should update com_documento" do
    patch com_documento_url(@com_documento), params: { com_documento: { doc_type: @com_documento.doc_type, issued_on: @com_documento.issued_on, titulo: @com_documento.titulo } }
    assert_redirected_to com_documento_url(@com_documento)
  end

  test "should destroy com_documento" do
    assert_difference("ComDocumento.count", -1) do
      delete com_documento_url(@com_documento)
    end

    assert_redirected_to com_documentos_url
  end
end
