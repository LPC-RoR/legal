require "test_helper"

class CtrPasosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ctr_paso = ctr_pasos(:one)
  end

  test "should get index" do
    get ctr_pasos_url
    assert_response :success
  end

  test "should get new" do
    get new_ctr_paso_url
    assert_response :success
  end

  test "should create ctr_paso" do
    assert_difference("CtrPaso.count") do
      post ctr_pasos_url, params: { ctr_paso: { codigo: @ctr_paso.codigo, glosa: @ctr_paso.glosa, orden: @ctr_paso.orden, rght: @ctr_paso.rght, tarea_id: @ctr_paso.tarea_id } }
    end

    assert_redirected_to ctr_paso_url(CtrPaso.last)
  end

  test "should show ctr_paso" do
    get ctr_paso_url(@ctr_paso)
    assert_response :success
  end

  test "should get edit" do
    get edit_ctr_paso_url(@ctr_paso)
    assert_response :success
  end

  test "should update ctr_paso" do
    patch ctr_paso_url(@ctr_paso), params: { ctr_paso: { codigo: @ctr_paso.codigo, glosa: @ctr_paso.glosa, orden: @ctr_paso.orden, rght: @ctr_paso.rght, tarea_id: @ctr_paso.tarea_id } }
    assert_redirected_to ctr_paso_url(@ctr_paso)
  end

  test "should destroy ctr_paso" do
    assert_difference("CtrPaso.count", -1) do
      delete ctr_paso_url(@ctr_paso)
    end

    assert_redirected_to ctr_pasos_url
  end
end
