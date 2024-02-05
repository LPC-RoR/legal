require "application_system_test_case"

class CalAnniosTest < ApplicationSystemTestCase
  setup do
    @cal_annio = cal_annios(:one)
  end

  test "visiting the index" do
    visit cal_annios_url
    assert_selector "h1", text: "Cal Annios"
  end

  test "creating a Cal annio" do
    visit cal_annios_url
    click_on "New Cal Annio"

    fill_in "Cal annio", with: @cal_annio.cal_annio
    click_on "Create Cal annio"

    assert_text "Cal annio was successfully created"
    click_on "Back"
  end

  test "updating a Cal annio" do
    visit cal_annios_url
    click_on "Edit", match: :first

    fill_in "Cal annio", with: @cal_annio.cal_annio
    click_on "Update Cal annio"

    assert_text "Cal annio was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal annio" do
    visit cal_annios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal annio was successfully destroyed"
  end
end
