require "application_system_test_case"

class AgeLogsTest < ApplicationSystemTestCase
  setup do
    @age_log = age_logs(:one)
  end

  test "visiting the index" do
    visit age_logs_url
    assert_selector "h1", text: "Age Logs"
  end

  test "creating a Age log" do
    visit age_logs_url
    click_on "New Age Log"

    fill_in "Age actividad", with: @age_log.age_actividad
    fill_in "Age actividad", with: @age_log.age_actividad_id
    fill_in "Fecha", with: @age_log.fecha
    click_on "Create Age log"

    assert_text "Age log was successfully created"
    click_on "Back"
  end

  test "updating a Age log" do
    visit age_logs_url
    click_on "Edit", match: :first

    fill_in "Age actividad", with: @age_log.age_actividad
    fill_in "Age actividad", with: @age_log.age_actividad_id
    fill_in "Fecha", with: @age_log.fecha
    click_on "Update Age log"

    assert_text "Age log was successfully updated"
    click_on "Back"
  end

  test "destroying a Age log" do
    visit age_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age log was successfully destroyed"
  end
end
