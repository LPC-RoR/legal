require "application_system_test_case"

class MDatosTest < ApplicationSystemTestCase
  setup do
    @m_dato = m_datos(:one)
  end

  test "visiting the index" do
    visit m_datos_url
    assert_selector "h1", text: "M Datos"
  end

  test "creating a M dato" do
    visit m_datos_url
    click_on "New M Dato"

    fill_in "Formula", with: @m_dato.formula
    fill_in "M dato", with: @m_dato.m_dato
    fill_in "M formato", with: @m_dato.m_formato_id
    fill_in "Split tag", with: @m_dato.split_tag
    fill_in "Tipo", with: @m_dato.tipo
    click_on "Create M dato"

    assert_text "M dato was successfully created"
    click_on "Back"
  end

  test "updating a M dato" do
    visit m_datos_url
    click_on "Edit", match: :first

    fill_in "Formula", with: @m_dato.formula
    fill_in "M dato", with: @m_dato.m_dato
    fill_in "M formato", with: @m_dato.m_formato_id
    fill_in "Split tag", with: @m_dato.split_tag
    fill_in "Tipo", with: @m_dato.tipo
    click_on "Update M dato"

    assert_text "M dato was successfully updated"
    click_on "Back"
  end

  test "destroying a M dato" do
    visit m_datos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M dato was successfully destroyed"
  end
end
