require "test_helper"

class DocDetallesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_detalle = doc_detalles(:one)
  end

  test "should get index" do
    get doc_detalles_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_detalle_url
    assert_response :success
  end

  test "should create doc_detalle" do
    assert_difference("DocDetalle.count") do
      post doc_detalles_url, params: { doc_detalle: { doc_emitido_id: @doc_detalle.doc_emitido_id, fecha_uf: @doc_detalle.fecha_uf, glosa: @doc_detalle.glosa, monto: @doc_detalle.monto, ownr_id: @doc_detalle.ownr_id, ownr_type: @doc_detalle.ownr_type, tipo_detalle: @doc_detalle.tipo_detalle } }
    end

    assert_redirected_to doc_detalle_url(DocDetalle.last)
  end

  test "should show doc_detalle" do
    get doc_detalle_url(@doc_detalle)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_detalle_url(@doc_detalle)
    assert_response :success
  end

  test "should update doc_detalle" do
    patch doc_detalle_url(@doc_detalle), params: { doc_detalle: { doc_emitido_id: @doc_detalle.doc_emitido_id, fecha_uf: @doc_detalle.fecha_uf, glosa: @doc_detalle.glosa, monto: @doc_detalle.monto, ownr_id: @doc_detalle.ownr_id, ownr_type: @doc_detalle.ownr_type, tipo_detalle: @doc_detalle.tipo_detalle } }
    assert_redirected_to doc_detalle_url(@doc_detalle)
  end

  test "should destroy doc_detalle" do
    assert_difference("DocDetalle.count", -1) do
      delete doc_detalle_url(@doc_detalle)
    end

    assert_redirected_to doc_detalles_url
  end
end
