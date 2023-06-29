require "application_system_test_case"

class MFormatosTest < ApplicationSystemTestCase
  setup do
    @m_formato = m_formatos(:one)
  end

  test "visiting the index" do
    visit m_formatos_url
    assert_selector "h1", text: "M Formatos"
  end

  test "creating a M formato" do
    visit m_formatos_url
    click_on "New M Formato"

    fill_in "M banco", with: @m_formato.m_banco_id
    fill_in "M formato", with: @m_formato.m_formato
    click_on "Create M formato"

    assert_text "M formato was successfully created"
    click_on "Back"
  end

  test "updating a M formato" do
    visit m_formatos_url
    click_on "Edit", match: :first

    fill_in "M banco", with: @m_formato.m_banco_id
    fill_in "M formato", with: @m_formato.m_formato
    click_on "Update M formato"

    assert_text "M formato was successfully updated"
    click_on "Back"
  end

  test "destroying a M formato" do
    visit m_formatos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M formato was successfully destroyed"
  end
end
