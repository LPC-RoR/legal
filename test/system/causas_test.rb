require "application_system_test_case"

class CausasTest < ApplicationSystemTestCase
  setup do
    @causa = causas(:one)
  end

  test "visiting the index" do
    visit causas_url
    assert_selector "h1", text: "Causas"
  end

  test "creating a Causa" do
    visit causas_url
    click_on "New Causa"

    fill_in "Causa", with: @causa.causa
    fill_in "Cliente", with: @causa.cliente_id
    fill_in "Identificador", with: @causa.identificador
    click_on "Create Causa"

    assert_text "Causa was successfully created"
    click_on "Back"
  end

  test "updating a Causa" do
    visit causas_url
    click_on "Edit", match: :first

    fill_in "Causa", with: @causa.causa
    fill_in "Cliente", with: @causa.cliente_id
    fill_in "Identificador", with: @causa.identificador
    click_on "Update Causa"

    assert_text "Causa was successfully updated"
    click_on "Back"
  end

  test "destroying a Causa" do
    visit causas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Causa was successfully destroyed"
  end
end
