require "application_system_test_case"

class CalSemanasTest < ApplicationSystemTestCase
  setup do
    @cal_semana = cal_semanas(:one)
  end

  test "visiting the index" do
    visit cal_semanas_url
    assert_selector "h1", text: "Cal Semanas"
  end

  test "creating a Cal semana" do
    visit cal_semanas_url
    click_on "New Cal Semana"

    fill_in "Cal semana", with: @cal_semana.cal_semana
    click_on "Create Cal semana"

    assert_text "Cal semana was successfully created"
    click_on "Back"
  end

  test "updating a Cal semana" do
    visit cal_semanas_url
    click_on "Edit", match: :first

    fill_in "Cal semana", with: @cal_semana.cal_semana
    click_on "Update Cal semana"

    assert_text "Cal semana was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal semana" do
    visit cal_semanas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal semana was successfully destroyed"
  end
end
