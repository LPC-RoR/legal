require "test_helper"

class DocTransaccionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_transaccion = doc_transacciones(:one)
  end

  test "should get index" do
    get doc_transacciones_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_transaccion_url
    assert_response :success
  end

  test "should create doc_transaccion" do
    assert_difference("DocTransaccion.count") do
      post doc_transacciones_url, params: { doc_transaccion: { descripcion: @doc_transaccion.descripcion } }
    end

    assert_redirected_to doc_transaccion_url(DocTransaccion.last)
  end

  test "should show doc_transaccion" do
    get doc_transaccion_url(@doc_transaccion)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_transaccion_url(@doc_transaccion)
    assert_response :success
  end

  test "should update doc_transaccion" do
    patch doc_transaccion_url(@doc_transaccion), params: { doc_transaccion: { descripcion: @doc_transaccion.descripcion } }
    assert_redirected_to doc_transaccion_url(@doc_transaccion)
  end

  test "should destroy doc_transaccion" do
    assert_difference("DocTransaccion.count", -1) do
      delete doc_transaccion_url(@doc_transaccion)
    end

    assert_redirected_to doc_transacciones_url
  end
end
