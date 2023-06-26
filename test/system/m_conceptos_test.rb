require "application_system_test_case"

class MConceptosTest < ApplicationSystemTestCase
  setup do
    @m_concepto = m_conceptos(:one)
  end

  test "visiting the index" do
    visit m_conceptos_url
    assert_selector "h1", text: "M Conceptos"
  end

  test "creating a M concepto" do
    visit m_conceptos_url
    click_on "New M Concepto"

    fill_in "M concepto", with: @m_concepto.m_concepto
    fill_in "M modelo", with: @m_concepto.m_modelo_id
    click_on "Create M concepto"

    assert_text "M concepto was successfully created"
    click_on "Back"
  end

  test "updating a M concepto" do
    visit m_conceptos_url
    click_on "Edit", match: :first

    fill_in "M concepto", with: @m_concepto.m_concepto
    fill_in "M modelo", with: @m_concepto.m_modelo_id
    click_on "Update M concepto"

    assert_text "M concepto was successfully updated"
    click_on "Back"
  end

  test "destroying a M concepto" do
    visit m_conceptos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M concepto was successfully destroyed"
  end
end
