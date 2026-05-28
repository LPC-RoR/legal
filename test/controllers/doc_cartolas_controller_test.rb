require "test_helper"

class DocCartolasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_cartola = doc_cartolas(:one)
  end

  test "should get index" do
    get doc_cartolas_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_cartola_url
    assert_response :success
  end

  test "should create doc_cartola" do
    assert_difference("DocCartola.count") do
      post doc_cartolas_url, params: { doc_cartola: { numero_cartola: @doc_cartola.numero_cartola } }
    end

    assert_redirected_to doc_cartola_url(DocCartola.last)
  end

  test "should show doc_cartola" do
    get doc_cartola_url(@doc_cartola)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_cartola_url(@doc_cartola)
    assert_response :success
  end

  test "should update doc_cartola" do
    patch doc_cartola_url(@doc_cartola), params: { doc_cartola: { numero_cartola: @doc_cartola.numero_cartola } }
    assert_redirected_to doc_cartola_url(@doc_cartola)
  end

  test "should destroy doc_cartola" do
    assert_difference("DocCartola.count", -1) do
      delete doc_cartola_url(@doc_cartola)
    end

    assert_redirected_to doc_cartolas_url
  end
end
