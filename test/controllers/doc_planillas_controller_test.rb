require "test_helper"

class DocPlanillasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_planilla = doc_planillas(:one)
  end

  test "should get index" do
    get doc_planillas_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_planilla_url
    assert_response :success
  end

  test "should create doc_planilla" do
    assert_difference("DocPlanilla.count") do
      post doc_planillas_url, params: { doc_planilla: { nombre_original: @doc_planilla.nombre_original } }
    end

    assert_redirected_to doc_planilla_url(DocPlanilla.last)
  end

  test "should show doc_planilla" do
    get doc_planilla_url(@doc_planilla)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_planilla_url(@doc_planilla)
    assert_response :success
  end

  test "should update doc_planilla" do
    patch doc_planilla_url(@doc_planilla), params: { doc_planilla: { nombre_original: @doc_planilla.nombre_original } }
    assert_redirected_to doc_planilla_url(@doc_planilla)
  end

  test "should destroy doc_planilla" do
    assert_difference("DocPlanilla.count", -1) do
      delete doc_planilla_url(@doc_planilla)
    end

    assert_redirected_to doc_planillas_url
  end
end
