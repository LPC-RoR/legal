require "application_system_test_case"

class DocDetallesTest < ApplicationSystemTestCase
  setup do
    @doc_detalle = doc_detalles(:one)
  end

  test "visiting the index" do
    visit doc_detalles_url
    assert_selector "h1", text: "Doc detalles"
  end

  test "should create doc detalle" do
    visit doc_detalles_url
    click_on "New doc detalle"

    fill_in "Doc emitido", with: @doc_detalle.doc_emitido_id
    fill_in "Fecha uf", with: @doc_detalle.fecha_uf
    fill_in "Glosa", with: @doc_detalle.glosa
    fill_in "Monto", with: @doc_detalle.monto
    fill_in "Ownr", with: @doc_detalle.ownr_id
    fill_in "Ownr type", with: @doc_detalle.ownr_type
    fill_in "Tipo detalle", with: @doc_detalle.tipo_detalle
    click_on "Create Doc detalle"

    assert_text "Doc detalle was successfully created"
    click_on "Back"
  end

  test "should update Doc detalle" do
    visit doc_detalle_url(@doc_detalle)
    click_on "Edit this doc detalle", match: :first

    fill_in "Doc emitido", with: @doc_detalle.doc_emitido_id
    fill_in "Fecha uf", with: @doc_detalle.fecha_uf
    fill_in "Glosa", with: @doc_detalle.glosa
    fill_in "Monto", with: @doc_detalle.monto
    fill_in "Ownr", with: @doc_detalle.ownr_id
    fill_in "Ownr type", with: @doc_detalle.ownr_type
    fill_in "Tipo detalle", with: @doc_detalle.tipo_detalle
    click_on "Update Doc detalle"

    assert_text "Doc detalle was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc detalle" do
    visit doc_detalle_url(@doc_detalle)
    click_on "Destroy this doc detalle", match: :first

    assert_text "Doc detalle was successfully destroyed"
  end
end
