require "test_helper"

class RepDocControladosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rep_doc_controlado = rep_doc_controlados(:one)
  end

  test "should get index" do
    get rep_doc_controlados_url
    assert_response :success
  end

  test "should get new" do
    get new_rep_doc_controlado_url
    assert_response :success
  end

  test "should create rep_doc_controlado" do
    assert_difference("RepDocControlado.count") do
      post rep_doc_controlados_url, params: { rep_doc_controlado: { archivo: @rep_doc_controlado.archivo, control: @rep_doc_controlado.control, orden: @rep_doc_controlado.orden, ownr_id: @rep_doc_controlado.ownr_id, ownr_type: @rep_doc_controlado.ownr_type, rep_doc_controlado: @rep_doc_controlado.rep_doc_controlado, tipo: @rep_doc_controlado.tipo } }
    end

    assert_redirected_to rep_doc_controlado_url(RepDocControlado.last)
  end

  test "should show rep_doc_controlado" do
    get rep_doc_controlado_url(@rep_doc_controlado)
    assert_response :success
  end

  test "should get edit" do
    get edit_rep_doc_controlado_url(@rep_doc_controlado)
    assert_response :success
  end

  test "should update rep_doc_controlado" do
    patch rep_doc_controlado_url(@rep_doc_controlado), params: { rep_doc_controlado: { archivo: @rep_doc_controlado.archivo, control: @rep_doc_controlado.control, orden: @rep_doc_controlado.orden, ownr_id: @rep_doc_controlado.ownr_id, ownr_type: @rep_doc_controlado.ownr_type, rep_doc_controlado: @rep_doc_controlado.rep_doc_controlado, tipo: @rep_doc_controlado.tipo } }
    assert_redirected_to rep_doc_controlado_url(@rep_doc_controlado)
  end

  test "should destroy rep_doc_controlado" do
    assert_difference("RepDocControlado.count", -1) do
      delete rep_doc_controlado_url(@rep_doc_controlado)
    end

    assert_redirected_to rep_doc_controlados_url
  end
end
