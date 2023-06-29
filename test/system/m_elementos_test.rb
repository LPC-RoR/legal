require "application_system_test_case"

class MElementosTest < ApplicationSystemTestCase
  setup do
    @m_elemento = m_elementos(:one)
  end

  test "visiting the index" do
    visit m_elementos_url
    assert_selector "h1", text: "M Elementos"
  end

  test "creating a M elemento" do
    visit m_elementos_url
    click_on "New M Elemento"

    fill_in "M elemento", with: @m_elemento.m_elemento
    fill_in "M formato", with: @m_elemento.m_formato_id
    fill_in "Orden", with: @m_elemento.orden
    fill_in "Tipo", with: @m_elemento.tipo
    click_on "Create M elemento"

    assert_text "M elemento was successfully created"
    click_on "Back"
  end

  test "updating a M elemento" do
    visit m_elementos_url
    click_on "Edit", match: :first

    fill_in "M elemento", with: @m_elemento.m_elemento
    fill_in "M formato", with: @m_elemento.m_formato_id
    fill_in "Orden", with: @m_elemento.orden
    fill_in "Tipo", with: @m_elemento.tipo
    click_on "Update M elemento"

    assert_text "M elemento was successfully updated"
    click_on "Back"
  end

  test "destroying a M elemento" do
    visit m_elementos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M elemento was successfully destroyed"
  end
end
