require "application_system_test_case"

class CalMesesTest < ApplicationSystemTestCase
  setup do
    @cal_mese = cal_meses(:one)
  end

  test "visiting the index" do
    visit cal_meses_url
    assert_selector "h1", text: "Cal Meses"
  end

  test "creating a Cal mes" do
    visit cal_meses_url
    click_on "New Cal Mes"

    fill_in "Cal mes", with: @cal_mese.cal_mes
    click_on "Create Cal mes"

    assert_text "Cal mes was successfully created"
    click_on "Back"
  end

  test "updating a Cal mes" do
    visit cal_meses_url
    click_on "Edit", match: :first

    fill_in "Cal mes", with: @cal_mese.cal_mes
    click_on "Update Cal mes"

    assert_text "Cal mes was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal mes" do
    visit cal_meses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal mes was successfully destroyed"
  end
end
