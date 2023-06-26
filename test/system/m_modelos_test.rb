require "application_system_test_case"

class MModelosTest < ApplicationSystemTestCase
  setup do
    @m_modelo = m_modelos(:one)
  end

  test "visiting the index" do
    visit m_modelos_url
    assert_selector "h1", text: "M Modelos"
  end

  test "creating a M modelo" do
    visit m_modelos_url
    click_on "New M Modelo"

    fill_in "M modelo", with: @m_modelo.m_modelo
    fill_in "Ownr class", with: @m_modelo.ownr_class
    fill_in "Ownr", with: @m_modelo.ownr_id
    click_on "Create M modelo"

    assert_text "M modelo was successfully created"
    click_on "Back"
  end

  test "updating a M modelo" do
    visit m_modelos_url
    click_on "Edit", match: :first

    fill_in "M modelo", with: @m_modelo.m_modelo
    fill_in "Ownr class", with: @m_modelo.ownr_class
    fill_in "Ownr", with: @m_modelo.ownr_id
    click_on "Update M modelo"

    assert_text "M modelo was successfully updated"
    click_on "Back"
  end

  test "destroying a M modelo" do
    visit m_modelos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M modelo was successfully destroyed"
  end
end
