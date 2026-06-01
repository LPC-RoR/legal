require "application_system_test_case"

class DocCierresTest < ApplicationSystemTestCase
  setup do
    @doc_cierre = doc_cierres(:one)
  end

  test "visiting the index" do
    visit doc_cierres_url
    assert_selector "h1", text: "Doc cierres"
  end

  test "should create doc cierre" do
    visit doc_cierres_url
    click_on "New doc cierre"

    fill_in "Encabezado", with: @doc_cierre.encabezado
    fill_in "Fecha inicio", with: @doc_cierre.fecha_inicio
    fill_in "Fecha termino", with: @doc_cierre.fecha_termino
    click_on "Create Doc cierre"

    assert_text "Doc cierre was successfully created"
    click_on "Back"
  end

  test "should update Doc cierre" do
    visit doc_cierre_url(@doc_cierre)
    click_on "Edit this doc cierre", match: :first

    fill_in "Encabezado", with: @doc_cierre.encabezado
    fill_in "Fecha inicio", with: @doc_cierre.fecha_inicio
    fill_in "Fecha termino", with: @doc_cierre.fecha_termino
    click_on "Update Doc cierre"

    assert_text "Doc cierre was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc cierre" do
    visit doc_cierre_url(@doc_cierre)
    click_on "Destroy this doc cierre", match: :first

    assert_text "Doc cierre was successfully destroyed"
  end
end
