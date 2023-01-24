require "application_system_test_case"

class TipoCausasTest < ApplicationSystemTestCase
  setup do
    @tipo_causa = tipo_causas(:one)
  end

  test "visiting the index" do
    visit tipo_causas_url
    assert_selector "h1", text: "Tipo Causas"
  end

  test "creating a Tipo causa" do
    visit tipo_causas_url
    click_on "New Tipo Causa"

    fill_in "Tipo causa", with: @tipo_causa.tipo_causa
    click_on "Create Tipo causa"

    assert_text "Tipo causa was successfully created"
    click_on "Back"
  end

  test "updating a Tipo causa" do
    visit tipo_causas_url
    click_on "Edit", match: :first

    fill_in "Tipo causa", with: @tipo_causa.tipo_causa
    click_on "Update Tipo causa"

    assert_text "Tipo causa was successfully updated"
    click_on "Back"
  end

  test "destroying a Tipo causa" do
    visit tipo_causas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tipo causa was successfully destroyed"
  end
end
