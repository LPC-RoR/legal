require "test_helper"

class DocHonorariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_honorario = doc_honorarios(:one)
  end

  test "should get index" do
    get doc_honorarios_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_honorario_url
    assert_response :success
  end

  test "should create doc_honorario" do
    assert_difference("DocHonorario.count") do
      post doc_honorarios_url, params: { doc_honorario: { contribuyente_rut: @doc_honorario.contribuyente_rut } }
    end

    assert_redirected_to doc_honorario_url(DocHonorario.last)
  end

  test "should show doc_honorario" do
    get doc_honorario_url(@doc_honorario)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_honorario_url(@doc_honorario)
    assert_response :success
  end

  test "should update doc_honorario" do
    patch doc_honorario_url(@doc_honorario), params: { doc_honorario: { contribuyente_rut: @doc_honorario.contribuyente_rut } }
    assert_redirected_to doc_honorario_url(@doc_honorario)
  end

  test "should destroy doc_honorario" do
    assert_difference("DocHonorario.count", -1) do
      delete doc_honorario_url(@doc_honorario)
    end

    assert_redirected_to doc_honorarios_url
  end
end
