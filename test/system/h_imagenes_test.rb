require "application_system_test_case"

class HImagenesTest < ApplicationSystemTestCase
  setup do
    @h_imagen = h_imagenes(:one)
  end

  test "visiting the index" do
    visit h_imagenes_url
    assert_selector "h1", text: "H Imagenes"
  end

  test "creating a H imagen" do
    visit h_imagenes_url
    click_on "New H Imagen"

    fill_in "Nombre", with: @h_imagen.nombre
    click_on "Create H imagen"

    assert_text "H imagen was successfully created"
    click_on "Back"
  end

  test "updating a H imagen" do
    visit h_imagenes_url
    click_on "Edit", match: :first

    fill_in "Nombre", with: @h_imagen.nombre
    click_on "Update H imagen"

    assert_text "H imagen was successfully updated"
    click_on "Back"
  end

  test "destroying a H imagen" do
    visit h_imagenes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "H imagen was successfully destroyed"
  end
end
