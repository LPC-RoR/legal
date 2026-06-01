require "test_helper"

class DocNotasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_nota = doc_notas(:one)
  end

  test "should get index" do
    get doc_notas_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_nota_url
    assert_response :success
  end

  test "should create doc_nota" do
    assert_difference("DocNota.count") do
      post doc_notas_url, params: { doc_nota: { nota: @doc_nota.nota, ownr_id: @doc_nota.ownr_id, ownr_type: @doc_nota.ownr_type } }
    end

    assert_redirected_to doc_nota_url(DocNota.last)
  end

  test "should show doc_nota" do
    get doc_nota_url(@doc_nota)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_nota_url(@doc_nota)
    assert_response :success
  end

  test "should update doc_nota" do
    patch doc_nota_url(@doc_nota), params: { doc_nota: { nota: @doc_nota.nota, ownr_id: @doc_nota.ownr_id, ownr_type: @doc_nota.ownr_type } }
    assert_redirected_to doc_nota_url(@doc_nota)
  end

  test "should destroy doc_nota" do
    assert_difference("DocNota.count", -1) do
      delete doc_nota_url(@doc_nota)
    end

    assert_redirected_to doc_notas_url
  end
end
