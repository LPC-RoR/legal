require "application_system_test_case"

class MMovimientosTest < ApplicationSystemTestCase
  setup do
    @m_movimiento = m_movimientos(:one)
  end

  test "visiting the index" do
    visit m_movimientos_url
    assert_selector "h1", text: "M Movimientos"
  end

  test "creating a M movimiento" do
    visit m_movimientos_url
    click_on "New M Movimiento"

    fill_in "Fecha", with: @m_movimiento.fecha
    fill_in "Glosa", with: @m_movimiento.glosa
    fill_in "M item", with: @m_movimiento.m_item_id
    fill_in "Monto", with: @m_movimiento.monto
    click_on "Create M movimiento"

    assert_text "M movimiento was successfully created"
    click_on "Back"
  end

  test "updating a M movimiento" do
    visit m_movimientos_url
    click_on "Edit", match: :first

    fill_in "Fecha", with: @m_movimiento.fecha
    fill_in "Glosa", with: @m_movimiento.glosa
    fill_in "M item", with: @m_movimiento.m_item_id
    fill_in "Monto", with: @m_movimiento.monto
    click_on "Update M movimiento"

    assert_text "M movimiento was successfully updated"
    click_on "Back"
  end

  test "destroying a M movimiento" do
    visit m_movimientos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M movimiento was successfully destroyed"
  end
end
