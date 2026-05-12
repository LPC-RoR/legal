require "test_helper"

class DocEmitidosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_emitido = doc_emitidos(:one)
  end

  test "should get index" do
    get doc_emitidos_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_emitido_url
    assert_response :success
  end

  test "should create doc_emitido" do
    assert_difference("DocEmitido.count") do
      post doc_emitidos_url, params: { doc_emitido: { nombre_original: @doc_emitido.nombre_original } }
    end

    assert_redirected_to doc_emitido_url(DocEmitido.last)
  end

  test "should show doc_emitido" do
    get doc_emitido_url(@doc_emitido)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_emitido_url(@doc_emitido)
    assert_response :success
  end

  test "should update doc_emitido" do
    patch doc_emitido_url(@doc_emitido), params: { doc_emitido: { nombre_original: @doc_emitido.nombre_original } }
    assert_redirected_to doc_emitido_url(@doc_emitido)
  end

  test "should destroy doc_emitido" do
    assert_difference("DocEmitido.count", -1) do
      delete doc_emitido_url(@doc_emitido)
    end

    assert_redirected_to doc_emitidos_url
  end
end
