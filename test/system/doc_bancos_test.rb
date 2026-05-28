require "application_system_test_case"

class DocBancosTest < ApplicationSystemTestCase
  setup do
    @doc_banco = doc_bancos(:one)
  end

  test "visiting the index" do
    visit doc_bancos_url
    assert_selector "h1", text: "Doc bancos"
  end

  test "should create doc banco" do
    visit doc_bancos_url
    click_on "New doc banco"

    fill_in "Nombre", with: @doc_banco.nombre
    fill_in "Rut", with: @doc_banco.rut
    click_on "Create Doc banco"

    assert_text "Doc banco was successfully created"
    click_on "Back"
  end

  test "should update Doc banco" do
    visit doc_banco_url(@doc_banco)
    click_on "Edit this doc banco", match: :first

    fill_in "Nombre", with: @doc_banco.nombre
    fill_in "Rut", with: @doc_banco.rut
    click_on "Update Doc banco"

    assert_text "Doc banco was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc banco" do
    visit doc_banco_url(@doc_banco)
    click_on "Destroy this doc banco", match: :first

    assert_text "Doc banco was successfully destroyed"
  end
end
