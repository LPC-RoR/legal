require "application_system_test_case"

class BlgTemasTest < ApplicationSystemTestCase
  setup do
    @blg_tema = blg_temas(:one)
  end

  test "visiting the index" do
    visit blg_temas_url
    assert_selector "h1", text: "Blg Temas"
  end

  test "creating a Blg tema" do
    visit blg_temas_url
    click_on "New Blg Tema"

    fill_in "Blg tema", with: @blg_tema.blg_tema
    click_on "Create Blg tema"

    assert_text "Blg tema was successfully created"
    click_on "Back"
  end

  test "updating a Blg tema" do
    visit blg_temas_url
    click_on "Edit", match: :first

    fill_in "Blg tema", with: @blg_tema.blg_tema
    click_on "Update Blg tema"

    assert_text "Blg tema was successfully updated"
    click_on "Back"
  end

  test "destroying a Blg tema" do
    visit blg_temas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Blg tema was successfully destroyed"
  end
end
