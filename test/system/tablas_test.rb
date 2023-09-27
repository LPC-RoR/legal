require "application_system_test_case"

class TablasTest < ApplicationSystemTestCase
  setup do
    @tabla = tablas(:one)
  end

  test "visiting the index" do
    visit tablas_url
    assert_selector "h1", text: "Tablas"
  end

  test "creating a Tabla" do
    visit tablas_url
    click_on "New Tabla"

    click_on "Create Tabla"

    assert_text "Tabla was successfully created"
    click_on "Back"
  end

  test "updating a Tabla" do
    visit tablas_url
    click_on "Edit", match: :first

    click_on "Update Tabla"

    assert_text "Tabla was successfully updated"
    click_on "Back"
  end

  test "destroying a Tabla" do
    visit tablas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tabla was successfully destroyed"
  end
end
