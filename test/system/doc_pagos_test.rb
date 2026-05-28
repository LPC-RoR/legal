require "application_system_test_case"

class DocPagosTest < ApplicationSystemTestCase
  setup do
    @doc_pago = doc_pagos(:one)
  end

  test "visiting the index" do
    visit doc_pagos_url
    assert_selector "h1", text: "Doc pagos"
  end

  test "should create doc pago" do
    visit doc_pagos_url
    click_on "New doc pago"

    fill_in "Doc transaccion", with: @doc_pago.doc_transaccion_id
    fill_in "Folio referencia", with: @doc_pago.folio_referencia
    fill_in "Monto", with: @doc_pago.monto
    fill_in "Ownr", with: @doc_pago.ownr_id
    fill_in "Ownr type", with: @doc_pago.ownr_type
    click_on "Create Doc pago"

    assert_text "Doc pago was successfully created"
    click_on "Back"
  end

  test "should update Doc pago" do
    visit doc_pago_url(@doc_pago)
    click_on "Edit this doc pago", match: :first

    fill_in "Doc transaccion", with: @doc_pago.doc_transaccion_id
    fill_in "Folio referencia", with: @doc_pago.folio_referencia
    fill_in "Monto", with: @doc_pago.monto
    fill_in "Ownr", with: @doc_pago.ownr_id
    fill_in "Ownr type", with: @doc_pago.ownr_type
    click_on "Update Doc pago"

    assert_text "Doc pago was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc pago" do
    visit doc_pago_url(@doc_pago)
    click_on "Destroy this doc pago", match: :first

    assert_text "Doc pago was successfully destroyed"
  end
end
