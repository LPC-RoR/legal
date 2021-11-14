require "application_system_test_case"

class StLogsTest < ApplicationSystemTestCase
  setup do
    @st_log = st_logs(:one)
  end

  test "visiting the index" do
    visit st_logs_url
    assert_selector "h1", text: "St Logs"
  end

  test "creating a St log" do
    visit st_logs_url
    click_on "New St Log"

    fill_in "Class name", with: @st_log.class_name
    fill_in "E destino", with: @st_log.e_destino
    fill_in "E origen", with: @st_log.e_origen
    fill_in "Objeto", with: @st_log.objeto_id
    fill_in "Perfil", with: @st_log.perfil_id
    click_on "Create St log"

    assert_text "St log was successfully created"
    click_on "Back"
  end

  test "updating a St log" do
    visit st_logs_url
    click_on "Edit", match: :first

    fill_in "Class name", with: @st_log.class_name
    fill_in "E destino", with: @st_log.e_destino
    fill_in "E origen", with: @st_log.e_origen
    fill_in "Objeto", with: @st_log.objeto_id
    fill_in "Perfil", with: @st_log.perfil_id
    click_on "Update St log"

    assert_text "St log was successfully updated"
    click_on "Back"
  end

  test "destroying a St log" do
    visit st_logs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "St log was successfully destroyed"
  end
end
