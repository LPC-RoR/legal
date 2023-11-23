require "application_system_test_case"

class MRegFactsTest < ApplicationSystemTestCase
  setup do
    @m_reg_fact = m_reg_facts(:one)
  end

  test "visiting the index" do
    visit m_reg_facts_url
    assert_selector "h1", text: "M Reg Facts"
  end

  test "creating a M reg fact" do
    visit m_reg_facts_url
    click_on "New M Reg Fact"

    fill_in "M registro", with: @m_reg_fact.m_registro_id
    fill_in "Monto", with: @m_reg_fact.monto
    fill_in "Tar factura", with: @m_reg_fact.tar_factura
    click_on "Create M reg fact"

    assert_text "M reg fact was successfully created"
    click_on "Back"
  end

  test "updating a M reg fact" do
    visit m_reg_facts_url
    click_on "Edit", match: :first

    fill_in "M registro", with: @m_reg_fact.m_registro_id
    fill_in "Monto", with: @m_reg_fact.monto
    fill_in "Tar factura", with: @m_reg_fact.tar_factura
    click_on "Update M reg fact"

    assert_text "M reg fact was successfully updated"
    click_on "Back"
  end

  test "destroying a M reg fact" do
    visit m_reg_facts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M reg fact was successfully destroyed"
  end
end
