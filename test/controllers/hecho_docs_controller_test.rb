require 'test_helper'

class HechoDocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hecho_doc = hecho_docs(:one)
  end

  test "should get index" do
    get hecho_docs_url
    assert_response :success
  end

  test "should get new" do
    get new_hecho_doc_url
    assert_response :success
  end

  test "should create hecho_doc" do
    assert_difference('HechoDoc.count') do
      post hecho_docs_url, params: { hecho_doc: { app_documento_id: @hecho_doc.app_documento_id, establece: @hecho_doc.establece, hecho_id: @hecho_doc.hecho_id } }
    end

    assert_redirected_to hecho_doc_url(HechoDoc.last)
  end

  test "should show hecho_doc" do
    get hecho_doc_url(@hecho_doc)
    assert_response :success
  end

  test "should get edit" do
    get edit_hecho_doc_url(@hecho_doc)
    assert_response :success
  end

  test "should update hecho_doc" do
    patch hecho_doc_url(@hecho_doc), params: { hecho_doc: { app_documento_id: @hecho_doc.app_documento_id, establece: @hecho_doc.establece, hecho_id: @hecho_doc.hecho_id } }
    assert_redirected_to hecho_doc_url(@hecho_doc)
  end

  test "should destroy hecho_doc" do
    assert_difference('HechoDoc.count', -1) do
      delete hecho_doc_url(@hecho_doc)
    end

    assert_redirected_to hecho_docs_url
  end
end
