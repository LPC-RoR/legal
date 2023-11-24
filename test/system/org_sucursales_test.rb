require "application_system_test_case"

class OrgSucursalesTest < ApplicationSystemTestCase
  setup do
    @org_sucursal = org_sucursales(:one)
  end

  test "visiting the index" do
    visit org_sucursales_url
    assert_selector "h1", text: "Org Sucursales"
  end

  test "creating a Org sucursal" do
    visit org_sucursales_url
    click_on "New Org Sucursal"

    fill_in "Direccion", with: @org_sucursal.direccion
    fill_in "Org sucursal", with: @org_sucursal.org_sucursal
    click_on "Create Org sucursal"

    assert_text "Org sucursal was successfully created"
    click_on "Back"
  end

  test "updating a Org sucursal" do
    visit org_sucursales_url
    click_on "Edit", match: :first

    fill_in "Direccion", with: @org_sucursal.direccion
    fill_in "Org sucursal", with: @org_sucursal.org_sucursal
    click_on "Update Org sucursal"

    assert_text "Org sucursal was successfully updated"
    click_on "Back"
  end

  test "destroying a Org sucursal" do
    visit org_sucursales_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Org sucursal was successfully destroyed"
  end
end
