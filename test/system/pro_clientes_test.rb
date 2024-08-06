require "application_system_test_case"

class ProClientesTest < ApplicationSystemTestCase
  setup do
    @pro_cliente = pro_clientes(:one)
  end

  test "visiting the index" do
    visit pro_clientes_url
    assert_selector "h1", text: "Pro clientes"
  end

  test "should create pro cliente" do
    visit pro_clientes_url
    click_on "New pro cliente"

    fill_in "Cliente", with: @pro_cliente.cliente_id
    fill_in "Producto", with: @pro_cliente.producto_id
    click_on "Create Pro cliente"

    assert_text "Pro cliente was successfully created"
    click_on "Back"
  end

  test "should update Pro cliente" do
    visit pro_cliente_url(@pro_cliente)
    click_on "Edit this pro cliente", match: :first

    fill_in "Cliente", with: @pro_cliente.cliente_id
    fill_in "Producto", with: @pro_cliente.producto_id
    click_on "Update Pro cliente"

    assert_text "Pro cliente was successfully updated"
    click_on "Back"
  end

  test "should destroy Pro cliente" do
    visit pro_cliente_url(@pro_cliente)
    click_on "Destroy this pro cliente", match: :first

    assert_text "Pro cliente was successfully destroyed"
  end
end
