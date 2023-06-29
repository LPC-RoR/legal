require "application_system_test_case"

class MPeriodosTest < ApplicationSystemTestCase
  setup do
    @m_periodo = m_periodos(:one)
  end

  test "visiting the index" do
    visit m_periodos_url
    assert_selector "h1", text: "M Periodos"
  end

  test "creating a M periodo" do
    visit m_periodos_url
    click_on "New M Periodo"

    fill_in "Clave", with: @m_periodo.clave
    fill_in "M modelo", with: @m_periodo.m_modelo_id
    fill_in "M periodo", with: @m_periodo.m_periodo
    click_on "Create M periodo"

    assert_text "M periodo was successfully created"
    click_on "Back"
  end

  test "updating a M periodo" do
    visit m_periodos_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @m_periodo.clave
    fill_in "M modelo", with: @m_periodo.m_modelo_id
    fill_in "M periodo", with: @m_periodo.m_periodo
    click_on "Update M periodo"

    assert_text "M periodo was successfully updated"
    click_on "Back"
  end

  test "destroying a M periodo" do
    visit m_periodos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M periodo was successfully destroyed"
  end
end
