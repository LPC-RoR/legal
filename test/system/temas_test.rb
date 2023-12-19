require "application_system_test_case"

class TemasTest < ApplicationSystemTestCase
  setup do
    @tema = temas(:one)
  end

  test "visiting the index" do
    visit temas_url
    assert_selector "h1", text: "Temas"
  end

  test "creating a Tema" do
    visit temas_url
    click_on "New Tema"

    fill_in "Causa", with: @tema.causa_id
    fill_in "Descripcion", with: @tema.descripcion
    fill_in "Orden", with: @tema.orden
    fill_in "Tema", with: @tema.tema
    click_on "Create Tema"

    assert_text "Tema was successfully created"
    click_on "Back"
  end

  test "updating a Tema" do
    visit temas_url
    click_on "Edit", match: :first

    fill_in "Causa", with: @tema.causa_id
    fill_in "Descripcion", with: @tema.descripcion
    fill_in "Orden", with: @tema.orden
    fill_in "Tema", with: @tema.tema
    click_on "Update Tema"

    assert_text "Tema was successfully updated"
    click_on "Back"
  end

  test "destroying a Tema" do
    visit temas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tema was successfully destroyed"
  end
end
