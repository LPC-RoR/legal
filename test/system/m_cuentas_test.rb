require "application_system_test_case"

class MCuentasTest < ApplicationSystemTestCase
  setup do
    @m_cuenta = m_cuentas(:one)
  end

  test "visiting the index" do
    visit m_cuentas_url
    assert_selector "h1", text: "M Cuentas"
  end

  test "creating a M cuenta" do
    visit m_cuentas_url
    click_on "New M Cuenta"

    fill_in "M banco", with: @m_cuenta.m_banco_id
    fill_in "M cuenta", with: @m_cuenta.m_cuenta
    click_on "Create M cuenta"

    assert_text "M cuenta was successfully created"
    click_on "Back"
  end

  test "updating a M cuenta" do
    visit m_cuentas_url
    click_on "Edit", match: :first

    fill_in "M banco", with: @m_cuenta.m_banco_id
    fill_in "M cuenta", with: @m_cuenta.m_cuenta
    click_on "Update M cuenta"

    assert_text "M cuenta was successfully updated"
    click_on "Back"
  end

  test "destroying a M cuenta" do
    visit m_cuentas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M cuenta was successfully destroyed"
  end
end
