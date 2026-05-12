require "application_system_test_case"

class DocEmitidosTest < ApplicationSystemTestCase
  setup do
    @doc_emitido = doc_emitidos(:one)
  end

  test "visiting the index" do
    visit doc_emitidos_url
    assert_selector "h1", text: "Doc emitidos"
  end

  test "should create doc emitido" do
    visit doc_emitidos_url
    click_on "New doc emitido"

    fill_in "Nombre original", with: @doc_emitido.nombre_original
    click_on "Create Doc emitido"

    assert_text "Doc emitido was successfully created"
    click_on "Back"
  end

  test "should update Doc emitido" do
    visit doc_emitido_url(@doc_emitido)
    click_on "Edit this doc emitido", match: :first

    fill_in "Nombre original", with: @doc_emitido.nombre_original
    click_on "Update Doc emitido"

    assert_text "Doc emitido was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc emitido" do
    visit doc_emitido_url(@doc_emitido)
    click_on "Destroy this doc emitido", match: :first

    assert_text "Doc emitido was successfully destroyed"
  end
end
