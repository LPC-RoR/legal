require "application_system_test_case"

class MRegistrosTest < ApplicationSystemTestCase
  setup do
    @m_registro = m_registros(:one)
  end

  test "visiting the index" do
    visit m_registros_url
    assert_selector "h1", text: "M Registros"
  end

  test "creating a M registro" do
    visit m_registros_url
    click_on "New M Registro"

    fill_in "Cargo abono", with: @m_registro.cargo_abono
    fill_in "Documento", with: @m_registro.documento
    fill_in "Fecha", with: @m_registro.fecha
    fill_in "Glosa", with: @m_registro.glosa
    fill_in "Glosa banco", with: @m_registro.glosa_banco
    fill_in "M conciliacion", with: @m_registro.m_conciliacion_id
    fill_in "M registro", with: @m_registro.m_registro
    fill_in "Monto", with: @m_registro.monto
    fill_in "Orden", with: @m_registro.orden
    fill_in "Saldo", with: @m_registro.saldo
    click_on "Create M registro"

    assert_text "M registro was successfully created"
    click_on "Back"
  end

  test "updating a M registro" do
    visit m_registros_url
    click_on "Edit", match: :first

    fill_in "Cargo abono", with: @m_registro.cargo_abono
    fill_in "Documento", with: @m_registro.documento
    fill_in "Fecha", with: @m_registro.fecha
    fill_in "Glosa", with: @m_registro.glosa
    fill_in "Glosa banco", with: @m_registro.glosa_banco
    fill_in "M conciliacion", with: @m_registro.m_conciliacion_id
    fill_in "M registro", with: @m_registro.m_registro
    fill_in "Monto", with: @m_registro.monto
    fill_in "Orden", with: @m_registro.orden
    fill_in "Saldo", with: @m_registro.saldo
    click_on "Update M registro"

    assert_text "M registro was successfully updated"
    click_on "Back"
  end

  test "destroying a M registro" do
    visit m_registros_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M registro was successfully destroyed"
  end
end
