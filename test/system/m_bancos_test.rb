require "application_system_test_case"

class MBancosTest < ApplicationSystemTestCase
  setup do
    @m_banco = m_bancos(:one)
  end

  test "visiting the index" do
    visit m_bancos_url
    assert_selector "h1", text: "M Bancos"
  end

  test "creating a M banco" do
    visit m_bancos_url
    click_on "New M Banco"

    fill_in "M banco", with: @m_banco.m_banco
    fill_in "M modelo", with: @m_banco.m_modelo_id
    click_on "Create M banco"

    assert_text "M banco was successfully created"
    click_on "Back"
  end

  test "updating a M banco" do
    visit m_bancos_url
    click_on "Edit", match: :first

    fill_in "M banco", with: @m_banco.m_banco
    fill_in "M modelo", with: @m_banco.m_modelo_id
    click_on "Update M banco"

    assert_text "M banco was successfully updated"
    click_on "Back"
  end

  test "destroying a M banco" do
    visit m_bancos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M banco was successfully destroyed"
  end
end
