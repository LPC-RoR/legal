require "application_system_test_case"

class AppVersionesTest < ApplicationSystemTestCase
  setup do
    @app_version = app_versiones(:one)
  end

  test "visiting the index" do
    visit app_versiones_url
    assert_selector "h1", text: "App Versiones"
  end

  test "creating a App version" do
    visit app_versiones_url
    click_on "New App Version"

    fill_in "App banner", with: @app_version.app_banner
    fill_in "App logo", with: @app_version.app_logo
    fill_in "App nombre", with: @app_version.app_nombre
    fill_in "App sigla", with: @app_version.app_sigla
    fill_in "Dog email", with: @app_version.dog_email
    click_on "Create App version"

    assert_text "App version was successfully created"
    click_on "Back"
  end

  test "updating a App version" do
    visit app_versiones_url
    click_on "Edit", match: :first

    fill_in "App banner", with: @app_version.app_banner
    fill_in "App logo", with: @app_version.app_logo
    fill_in "App nombre", with: @app_version.app_nombre
    fill_in "App sigla", with: @app_version.app_sigla
    fill_in "Dog email", with: @app_version.dog_email
    click_on "Update App version"

    assert_text "App version was successfully updated"
    click_on "Back"
  end

  test "destroying a App version" do
    visit app_versiones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App version was successfully destroyed"
  end
end
