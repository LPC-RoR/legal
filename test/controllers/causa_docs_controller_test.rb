require 'test_helper'

class CausaDocsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @causa_doc = causa_docs(:one)
  end

  test "should get index" do
    get causa_docs_url
    assert_response :success
  end

  test "should get new" do
    get new_causa_doc_url
    assert_response :success
  end

  test "should create causa_doc" do
    assert_difference('CausaDoc.count') do
      post causa_docs_url, params: { causa_doc: { app_documento_id: @causa_doc.app_documento_id, causa_id: @causa_doc.causa_id } }
    end

    assert_redirected_to causa_doc_url(CausaDoc.last)
  end

  test "should show causa_doc" do
    get causa_doc_url(@causa_doc)
    assert_response :success
  end

  test "should get edit" do
    get edit_causa_doc_url(@causa_doc)
    assert_response :success
  end

  test "should update causa_doc" do
    patch causa_doc_url(@causa_doc), params: { causa_doc: { app_documento_id: @causa_doc.app_documento_id, causa_id: @causa_doc.causa_id } }
    assert_redirected_to causa_doc_url(@causa_doc)
  end

  test "should destroy causa_doc" do
    assert_difference('CausaDoc.count', -1) do
      delete causa_doc_url(@causa_doc)
    end

    assert_redirected_to causa_docs_url
  end
end
