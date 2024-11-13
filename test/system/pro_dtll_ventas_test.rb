require "application_system_test_case"

class ProDtllVentasTest < ApplicationSystemTestCase
  setup do
    @pro_dtll_venta = pro_dtll_ventas(:one)
  end

  test "visiting the index" do
    visit pro_dtll_ventas_url
    assert_selector "h1", text: "Pro dtll ventas"
  end

  test "should create pro dtll venta" do
    visit pro_dtll_ventas_url
    click_on "New pro dtll venta"

    fill_in "Fecha activacion", with: @pro_dtll_venta.fecha_activacion
    fill_in "Ownr", with: @pro_dtll_venta.ownr_id
    fill_in "Ownr type", with: @pro_dtll_venta.ownr_type
    fill_in "Producto", with: @pro_dtll_venta.producto_id
    click_on "Create Pro dtll venta"

    assert_text "Pro dtll venta was successfully created"
    click_on "Back"
  end

  test "should update Pro dtll venta" do
    visit pro_dtll_venta_url(@pro_dtll_venta)
    click_on "Edit this pro dtll venta", match: :first

    fill_in "Fecha activacion", with: @pro_dtll_venta.fecha_activacion
    fill_in "Ownr", with: @pro_dtll_venta.ownr_id
    fill_in "Ownr type", with: @pro_dtll_venta.ownr_type
    fill_in "Producto", with: @pro_dtll_venta.producto_id
    click_on "Update Pro dtll venta"

    assert_text "Pro dtll venta was successfully updated"
    click_on "Back"
  end

  test "should destroy Pro dtll venta" do
    visit pro_dtll_venta_url(@pro_dtll_venta)
    click_on "Destroy this pro dtll venta", match: :first

    assert_text "Pro dtll venta was successfully destroyed"
  end
end
