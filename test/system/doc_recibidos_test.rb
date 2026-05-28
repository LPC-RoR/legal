require "application_system_test_case"

class DocRecibidosTest < ApplicationSystemTestCase
  setup do
    @doc_recibido = doc_recibidos(:one)
  end

  test "visiting the index" do
    visit doc_recibidos_url
    assert_selector "h1", text: "Doc recibidos"
  end

  test "should create doc recibido" do
    visit doc_recibidos_url
    click_on "New doc recibido"

    fill_in "Rut emisor", with: @doc_recibido.rut_emisor
    click_on "Create Doc recibido"

    assert_text "Doc recibido was successfully created"
    click_on "Back"
  end

  test "should update Doc recibido" do
    visit doc_recibido_url(@doc_recibido)
    click_on "Edit this doc recibido", match: :first

    fill_in "Rut emisor", with: @doc_recibido.rut_emisor
    click_on "Update Doc recibido"

    assert_text "Doc recibido was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc recibido" do
    visit doc_recibido_url(@doc_recibido)
    click_on "Destroy this doc recibido", match: :first

    assert_text "Doc recibido was successfully destroyed"
  end
end
