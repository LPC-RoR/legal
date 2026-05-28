require "application_system_test_case"

class DocCuentasTest < ApplicationSystemTestCase
  setup do
    @doc_cuenta = doc_cuentas(:one)
  end

  test "visiting the index" do
    visit doc_cuentas_url
    assert_selector "h1", text: "Doc cuentas"
  end

  test "should create doc cuenta" do
    visit doc_cuentas_url
    click_on "New doc cuenta"

    fill_in "Sucursal", with: @doc_cuenta.sucursal
    click_on "Create Doc cuenta"

    assert_text "Doc cuenta was successfully created"
    click_on "Back"
  end

  test "should update Doc cuenta" do
    visit doc_cuenta_url(@doc_cuenta)
    click_on "Edit this doc cuenta", match: :first

    fill_in "Sucursal", with: @doc_cuenta.sucursal
    click_on "Update Doc cuenta"

    assert_text "Doc cuenta was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc cuenta" do
    visit doc_cuenta_url(@doc_cuenta)
    click_on "Destroy this doc cuenta", match: :first

    assert_text "Doc cuenta was successfully destroyed"
  end
end
