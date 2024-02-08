require "application_system_test_case"

class AgeUsuActsTest < ApplicationSystemTestCase
  setup do
    @age_usu_act = age_usu_acts(:one)
  end

  test "visiting the index" do
    visit age_usu_acts_url
    assert_selector "h1", text: "Age Usu Acts"
  end

  test "creating a Age usu act" do
    visit age_usu_acts_url
    click_on "New Age Usu Act"

    fill_in "Age actividad", with: @age_usu_act.age_actividad_id
    fill_in "Age usuario", with: @age_usu_act.age_usuario_id
    click_on "Create Age usu act"

    assert_text "Age usu act was successfully created"
    click_on "Back"
  end

  test "updating a Age usu act" do
    visit age_usu_acts_url
    click_on "Edit", match: :first

    fill_in "Age actividad", with: @age_usu_act.age_actividad_id
    fill_in "Age usuario", with: @age_usu_act.age_usuario_id
    click_on "Update Age usu act"

    assert_text "Age usu act was successfully updated"
    click_on "Back"
  end

  test "destroying a Age usu act" do
    visit age_usu_acts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age usu act was successfully destroyed"
  end
end
