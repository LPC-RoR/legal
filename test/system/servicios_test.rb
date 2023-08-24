require "application_system_test_case"

class ServiciosTest < ApplicationSystemTestCase
  setup do
    @servicio = servicios(:one)
  end

  test "visiting the index" do
    visit servicios_url
    assert_selector "h1", text: "Servicios"
  end

  test "creating a Servicio" do
    visit servicios_url
    click_on "New Servicio"

    click_on "Create Servicio"

    assert_text "Servicio was successfully created"
    click_on "Back"
  end

  test "updating a Servicio" do
    visit servicios_url
    click_on "Edit", match: :first

    click_on "Update Servicio"

    assert_text "Servicio was successfully updated"
    click_on "Back"
  end

  test "destroying a Servicio" do
    visit servicios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Servicio was successfully destroyed"
  end
end
