require "application_system_test_case"

class AppObservacionesTest < ApplicationSystemTestCase
  setup do
    @app_observacion = app_observaciones(:one)
  end

  test "visiting the index" do
    visit app_observaciones_url
    assert_selector "h1", text: "App Observaciones"
  end

  test "creating a App observacion" do
    visit app_observaciones_url
    click_on "New App Observacion"

    fill_in "Detalle", with: @app_observacion.detalle
    fill_in "Owner class", with: @app_observacion.owner_class
    fill_in "Owner", with: @app_observacion.owner_id
    fill_in "Perfil", with: @app_observacion.perfil_id
    click_on "Create App observacion"

    assert_text "App observacion was successfully created"
    click_on "Back"
  end

  test "updating a App observacion" do
    visit app_observaciones_url
    click_on "Edit", match: :first

    fill_in "Detalle", with: @app_observacion.detalle
    fill_in "Owner class", with: @app_observacion.owner_class
    fill_in "Owner", with: @app_observacion.owner_id
    fill_in "Perfil", with: @app_observacion.perfil_id
    click_on "Update App observacion"

    assert_text "App observacion was successfully updated"
    click_on "Back"
  end

  test "destroying a App observacion" do
    visit app_observaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App observacion was successfully destroyed"
  end
end
