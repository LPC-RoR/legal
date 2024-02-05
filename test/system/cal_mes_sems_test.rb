require "application_system_test_case"

class CalMesSemsTest < ApplicationSystemTestCase
  setup do
    @cal_mes_sem = cal_mes_sems(:one)
  end

  test "visiting the index" do
    visit cal_mes_sems_url
    assert_selector "h1", text: "Cal Mes Sems"
  end

  test "creating a Cal mes sem" do
    visit cal_mes_sems_url
    click_on "New Cal Mes Sem"

    fill_in "Cal mes", with: @cal_mes_sem.cal_mes_id
    fill_in "Cal semana", with: @cal_mes_sem.cal_semana_id
    click_on "Create Cal mes sem"

    assert_text "Cal mes sem was successfully created"
    click_on "Back"
  end

  test "updating a Cal mes sem" do
    visit cal_mes_sems_url
    click_on "Edit", match: :first

    fill_in "Cal mes", with: @cal_mes_sem.cal_mes_id
    fill_in "Cal semana", with: @cal_mes_sem.cal_semana_id
    click_on "Update Cal mes sem"

    assert_text "Cal mes sem was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal mes sem" do
    visit cal_mes_sems_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal mes sem was successfully destroyed"
  end
end
