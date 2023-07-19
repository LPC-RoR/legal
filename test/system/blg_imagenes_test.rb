require "application_system_test_case"

class BlgImagenesTest < ApplicationSystemTestCase
  setup do
    @blg_imagen = blg_imagenes(:one)
  end

  test "visiting the index" do
    visit blg_imagenes_url
    assert_selector "h1", text: "Blg Imagenes"
  end

  test "creating a Blg imagen" do
    visit blg_imagenes_url
    click_on "New Blg Imagen"

    fill_in "Blg credito", with: @blg_imagen.blg_credito
    fill_in "Blg imagen", with: @blg_imagen.blg_imagen
    fill_in "Imagen", with: @blg_imagen.imagen
    fill_in "Ownr class", with: @blg_imagen.ownr_class
    fill_in "Ownr", with: @blg_imagen.ownr_id
    click_on "Create Blg imagen"

    assert_text "Blg imagen was successfully created"
    click_on "Back"
  end

  test "updating a Blg imagen" do
    visit blg_imagenes_url
    click_on "Edit", match: :first

    fill_in "Blg credito", with: @blg_imagen.blg_credito
    fill_in "Blg imagen", with: @blg_imagen.blg_imagen
    fill_in "Imagen", with: @blg_imagen.imagen
    fill_in "Ownr class", with: @blg_imagen.ownr_class
    fill_in "Ownr", with: @blg_imagen.ownr_id
    click_on "Update Blg imagen"

    assert_text "Blg imagen was successfully updated"
    click_on "Back"
  end

  test "destroying a Blg imagen" do
    visit blg_imagenes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Blg imagen was successfully destroyed"
  end
end
