require "test_helper"

class DocCierresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_cierre = doc_cierres(:one)
  end

  test "should get index" do
    get doc_cierres_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_cierre_url
    assert_response :success
  end

  test "should create doc_cierre" do
    assert_difference("DocCierre.count") do
      post doc_cierres_url, params: { doc_cierre: { encabezado: @doc_cierre.encabezado, fecha_inicio: @doc_cierre.fecha_inicio, fecha_termino: @doc_cierre.fecha_termino } }
    end

    assert_redirected_to doc_cierre_url(DocCierre.last)
  end

  test "should show doc_cierre" do
    get doc_cierre_url(@doc_cierre)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_cierre_url(@doc_cierre)
    assert_response :success
  end

  test "should update doc_cierre" do
    patch doc_cierre_url(@doc_cierre), params: { doc_cierre: { encabezado: @doc_cierre.encabezado, fecha_inicio: @doc_cierre.fecha_inicio, fecha_termino: @doc_cierre.fecha_termino } }
    assert_redirected_to doc_cierre_url(@doc_cierre)
  end

  test "should destroy doc_cierre" do
    assert_difference("DocCierre.count", -1) do
      delete doc_cierre_url(@doc_cierre)
    end

    assert_redirected_to doc_cierres_url
  end
end
