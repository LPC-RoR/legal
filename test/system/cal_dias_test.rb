require "application_system_test_case"

class CalDiasTest < ApplicationSystemTestCase
  setup do
    @cal_dia = cal_dias(:one)
  end

  test "visiting the index" do
    visit cal_dias_url
    assert_selector "h1", text: "Cal Dias"
  end

  test "creating a Cal dia" do
    visit cal_dias_url
    click_on "New Cal Dia"

    fill_in "Cal dia", with: @cal_dia.cal_dia
    click_on "Create Cal dia"

    assert_text "Cal dia was successfully created"
    click_on "Back"
  end

  test "updating a Cal dia" do
    visit cal_dias_url
    click_on "Edit", match: :first

    fill_in "Cal dia", with: @cal_dia.cal_dia
    click_on "Update Cal dia"

    assert_text "Cal dia was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal dia" do
    visit cal_dias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal dia was successfully destroyed"
  end
end
