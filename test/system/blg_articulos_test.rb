require "application_system_test_case"

class BlgArticulosTest < ApplicationSystemTestCase
  setup do
    @blg_articulo = blg_articulos(:one)
  end

  test "visiting the index" do
    visit blg_articulos_url
    assert_selector "h1", text: "Blg Articulos"
  end

  test "creating a Blg articulo" do
    visit blg_articulos_url
    click_on "New Blg Articulo"

    fill_in "App perfil", with: @blg_articulo.app_perfil_id
    fill_in "Articulo", with: @blg_articulo.articulo
    fill_in "Blg articulo", with: @blg_articulo.blg_articulo
    fill_in "Blg tema", with: @blg_articulo.blg_tema_id
    fill_in "Estado", with: @blg_articulo.estado
    click_on "Create Blg articulo"

    assert_text "Blg articulo was successfully created"
    click_on "Back"
  end

  test "updating a Blg articulo" do
    visit blg_articulos_url
    click_on "Edit", match: :first

    fill_in "App perfil", with: @blg_articulo.app_perfil_id
    fill_in "Articulo", with: @blg_articulo.articulo
    fill_in "Blg articulo", with: @blg_articulo.blg_articulo
    fill_in "Blg tema", with: @blg_articulo.blg_tema_id
    fill_in "Estado", with: @blg_articulo.estado
    click_on "Update Blg articulo"

    assert_text "Blg articulo was successfully updated"
    click_on "Back"
  end

  test "destroying a Blg articulo" do
    visit blg_articulos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Blg articulo was successfully destroyed"
  end
end
