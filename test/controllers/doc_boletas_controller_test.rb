require "test_helper"

class DocBoletasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_boleta = doc_boletas(:one)
  end

  test "should get index" do
    get doc_boletas_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_boleta_url
    assert_response :success
  end

  test "should create doc_boleta" do
    assert_difference("DocBoleta.count") do
      post doc_boletas_url, params: { doc_boleta: { emisor_rut: @doc_boleta.emisor_rut } }
    end

    assert_redirected_to doc_boleta_url(DocBoleta.last)
  end

  test "should show doc_boleta" do
    get doc_boleta_url(@doc_boleta)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_boleta_url(@doc_boleta)
    assert_response :success
  end

  test "should update doc_boleta" do
    patch doc_boleta_url(@doc_boleta), params: { doc_boleta: { emisor_rut: @doc_boleta.emisor_rut } }
    assert_redirected_to doc_boleta_url(@doc_boleta)
  end

  test "should destroy doc_boleta" do
    assert_difference("DocBoleta.count", -1) do
      delete doc_boleta_url(@doc_boleta)
    end

    assert_redirected_to doc_boletas_url
  end
end
