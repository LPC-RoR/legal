require "test_helper"

class DocPagosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doc_pago = doc_pagos(:one)
  end

  test "should get index" do
    get doc_pagos_url
    assert_response :success
  end

  test "should get new" do
    get new_doc_pago_url
    assert_response :success
  end

  test "should create doc_pago" do
    assert_difference("DocPago.count") do
      post doc_pagos_url, params: { doc_pago: { doc_transaccion_id: @doc_pago.doc_transaccion_id, folio_referencia: @doc_pago.folio_referencia, monto: @doc_pago.monto, ownr_id: @doc_pago.ownr_id, ownr_type: @doc_pago.ownr_type } }
    end

    assert_redirected_to doc_pago_url(DocPago.last)
  end

  test "should show doc_pago" do
    get doc_pago_url(@doc_pago)
    assert_response :success
  end

  test "should get edit" do
    get edit_doc_pago_url(@doc_pago)
    assert_response :success
  end

  test "should update doc_pago" do
    patch doc_pago_url(@doc_pago), params: { doc_pago: { doc_transaccion_id: @doc_pago.doc_transaccion_id, folio_referencia: @doc_pago.folio_referencia, monto: @doc_pago.monto, ownr_id: @doc_pago.ownr_id, ownr_type: @doc_pago.ownr_type } }
    assert_redirected_to doc_pago_url(@doc_pago)
  end

  test "should destroy doc_pago" do
    assert_difference("DocPago.count", -1) do
      delete doc_pago_url(@doc_pago)
    end

    assert_redirected_to doc_pagos_url
  end
end
