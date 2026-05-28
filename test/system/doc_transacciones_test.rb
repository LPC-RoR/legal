require "application_system_test_case"

class DocTransaccionesTest < ApplicationSystemTestCase
  setup do
    @doc_transaccion = doc_transacciones(:one)
  end

  test "visiting the index" do
    visit doc_transacciones_url
    assert_selector "h1", text: "Doc transacciones"
  end

  test "should create doc transaccion" do
    visit doc_transacciones_url
    click_on "New doc transaccion"

    fill_in "Descripcion", with: @doc_transaccion.descripcion
    click_on "Create Doc transaccion"

    assert_text "Doc transaccion was successfully created"
    click_on "Back"
  end

  test "should update Doc transaccion" do
    visit doc_transaccion_url(@doc_transaccion)
    click_on "Edit this doc transaccion", match: :first

    fill_in "Descripcion", with: @doc_transaccion.descripcion
    click_on "Update Doc transaccion"

    assert_text "Doc transaccion was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc transaccion" do
    visit doc_transaccion_url(@doc_transaccion)
    click_on "Destroy this doc transaccion", match: :first

    assert_text "Doc transaccion was successfully destroyed"
  end
end
