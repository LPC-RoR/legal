require "test_helper"

class DocRecibidosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_recibido = doc_recibidos(:one)
  end

  test "should get index" do
    get doc_recibidos_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_recibido_url
    assert_response :success
  end

  test "should create doc_recibido" do
    assert_difference("DocRecibido.count") do
      post doc_recibidos_url, params: { doc_recibido: { rut_emisor: @doc_recibido.rut_emisor } }
    end

    assert_redirected_to doc_recibido_url(DocRecibido.last)
  end

  test "should show doc_recibido" do
    get doc_recibido_url(@doc_recibido)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_recibido_url(@doc_recibido)
    assert_response :success
  end

  test "should update doc_recibido" do
    patch doc_recibido_url(@doc_recibido), params: { doc_recibido: { rut_emisor: @doc_recibido.rut_emisor } }
    assert_redirected_to doc_recibido_url(@doc_recibido)
  end

  test "should destroy doc_recibido" do
    assert_difference("DocRecibido.count", -1) do
      delete doc_recibido_url(@doc_recibido)
    end

    assert_redirected_to doc_recibidos_url
  end
end
