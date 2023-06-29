require "application_system_test_case"

class MValoresTest < ApplicationSystemTestCase
  setup do
    @m_valor = m_valores(:one)
  end

  test "visiting the index" do
    visit m_valores_url
    assert_selector "h1", text: "M Valores"
  end

  test "creating a M valor" do
    visit m_valores_url
    click_on "New M Valor"

    fill_in "M conciliacion", with: @m_valor.m_conciliacion_id
    fill_in "M valor", with: @m_valor.m_valor
    fill_in "Orden", with: @m_valor.orden
    fill_in "Tipo", with: @m_valor.tipo
    fill_in "Valor", with: @m_valor.valor
    click_on "Create M valor"

    assert_text "M valor was successfully created"
    click_on "Back"
  end

  test "updating a M valor" do
    visit m_valores_url
    click_on "Edit", match: :first

    fill_in "M conciliacion", with: @m_valor.m_conciliacion_id
    fill_in "M valor", with: @m_valor.m_valor
    fill_in "Orden", with: @m_valor.orden
    fill_in "Tipo", with: @m_valor.tipo
    fill_in "Valor", with: @m_valor.valor
    click_on "Update M valor"

    assert_text "M valor was successfully updated"
    click_on "Back"
  end

  test "destroying a M valor" do
    visit m_valores_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M valor was successfully destroyed"
  end
end
