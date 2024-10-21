require "application_system_test_case"

class CuentasTest < ApplicationSystemTestCase
  setup do
    @cuenta = cuentas(:one)
  end

  test "visiting the index" do
    visit cuentas_url
    assert_selector "h1", text: "Cuentas"
  end

  test "should create cuenta" do
    visit cuentas_url
    click_on "New cuenta"

    click_on "Create Cuenta"

    assert_text "Cuenta was successfully created"
    click_on "Back"
  end

  test "should update Cuenta" do
    visit cuenta_url(@cuenta)
    click_on "Edit this cuenta", match: :first

    click_on "Update Cuenta"

    assert_text "Cuenta was successfully updated"
    click_on "Back"
  end

  test "should destroy Cuenta" do
    visit cuenta_url(@cuenta)
    click_on "Destroy this cuenta", match: :first

    assert_text "Cuenta was successfully destroyed"
  end
end
