require "test_helper"

class DocBancosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_banco = doc_bancos(:one)
  end

  test "should get index" do
    get doc_bancos_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_banco_url
    assert_response :success
  end

  test "should create doc_banco" do
    assert_difference("DocBanco.count") do
      post doc_bancos_url, params: { doc_banco: { nombre: @doc_banco.nombre, rut: @doc_banco.rut } }
    end

    assert_redirected_to doc_banco_url(DocBanco.last)
  end

  test "should show doc_banco" do
    get doc_banco_url(@doc_banco)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_banco_url(@doc_banco)
    assert_response :success
  end

  test "should update doc_banco" do
    patch doc_banco_url(@doc_banco), params: { doc_banco: { nombre: @doc_banco.nombre, rut: @doc_banco.rut } }
    assert_redirected_to doc_banco_url(@doc_banco)
  end

  test "should destroy doc_banco" do
    assert_difference("DocBanco.count", -1) do
      delete doc_banco_url(@doc_banco)
    end

    assert_redirected_to doc_bancos_url
  end
end
