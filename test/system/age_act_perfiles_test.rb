require "application_system_test_case"

class AgeActPerfilesTest < ApplicationSystemTestCase
  setup do
    @age_act_perfil = age_act_perfiles(:one)
  end

  test "visiting the index" do
    visit age_act_perfiles_url
    assert_selector "h1", text: "Age Act Perfiles"
  end

  test "creating a Age act perfil" do
    visit age_act_perfiles_url
    click_on "New Age Act Perfil"

    fill_in "Age actividad", with: @age_act_perfil.age_actividad_id
    fill_in "App perfil", with: @age_act_perfil.app_perfil_id
    click_on "Create Age act perfil"

    assert_text "Age act perfil was successfully created"
    click_on "Back"
  end

  test "updating a Age act perfil" do
    visit age_act_perfiles_url
    click_on "Edit", match: :first

    fill_in "Age actividad", with: @age_act_perfil.age_actividad_id
    fill_in "App perfil", with: @age_act_perfil.app_perfil_id
    click_on "Update Age act perfil"

    assert_text "Age act perfil was successfully updated"
    click_on "Back"
  end

  test "destroying a Age act perfil" do
    visit age_act_perfiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age act perfil was successfully destroyed"
  end
end
