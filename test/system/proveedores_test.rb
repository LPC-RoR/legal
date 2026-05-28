require "application_system_test_case"

class ProveedoresTest < ApplicationSystemTestCase
  setup do
    @proveedor = proveedores(:one)
  end

  test "visiting the index" do
    visit proveedores_url
    assert_selector "h1", text: "Proveedores"
  end

  test "should create proveedor" do
    visit proveedores_url
    click_on "New proveedor"

    fill_in "Razon social", with: @proveedor.razon_social
    fill_in "Rut", with: @proveedor.rut
    click_on "Create Proveedor"

    assert_text "Proveedor was successfully created"
    click_on "Back"
  end

  test "should update Proveedor" do
    visit proveedor_url(@proveedor)
    click_on "Edit this proveedor", match: :first

    fill_in "Razon social", with: @proveedor.razon_social
    fill_in "Rut", with: @proveedor.rut
    click_on "Update Proveedor"

    assert_text "Proveedor was successfully updated"
    click_on "Back"
  end

  test "should destroy Proveedor" do
    visit proveedor_url(@proveedor)
    click_on "Destroy this proveedor", match: :first

    assert_text "Proveedor was successfully destroyed"
  end
end
