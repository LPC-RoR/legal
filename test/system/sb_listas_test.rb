require "application_system_test_case"

class SbListasTest < ApplicationSystemTestCase
  setup do
    @sb_lista = sb_listas(:one)
  end

  test "visiting the index" do
    visit sb_listas_url
    assert_selector "h1", text: "Sb Listas"
  end

  test "creating a Sb lista" do
    visit sb_listas_url
    click_on "New Sb Lista"

    fill_in "Acceso", with: @sb_lista.acceso
    check "Activa" if @sb_lista.activa
    fill_in "Link", with: @sb_lista.link
    fill_in "Lista", with: @sb_lista.lista
    click_on "Create Sb lista"

    assert_text "Sb lista was successfully created"
    click_on "Back"
  end

  test "updating a Sb lista" do
    visit sb_listas_url
    click_on "Edit", match: :first

    fill_in "Acceso", with: @sb_lista.acceso
    check "Activa" if @sb_lista.activa
    fill_in "Link", with: @sb_lista.link
    fill_in "Lista", with: @sb_lista.lista
    click_on "Update Sb lista"

    assert_text "Sb lista was successfully updated"
    click_on "Back"
  end

  test "destroying a Sb lista" do
    visit sb_listas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sb lista was successfully destroyed"
  end
end
