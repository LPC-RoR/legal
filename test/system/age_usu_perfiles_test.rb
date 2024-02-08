require "application_system_test_case"

class AgeUsuPerfilesTest < ApplicationSystemTestCase
  setup do
    @age_usu_perfil = age_usu_perfiles(:one)
  end

  test "visiting the index" do
    visit age_usu_perfiles_url
    assert_selector "h1", text: "Age Usu Perfiles"
  end

  test "creating a Age usu perfil" do
    visit age_usu_perfiles_url
    click_on "New Age Usu Perfil"

    fill_in "Age usuario", with: @age_usu_perfil.age_usuario_id
    fill_in "App perfil", with: @age_usu_perfil.app_perfil_id
    click_on "Create Age usu perfil"

    assert_text "Age usu perfil was successfully created"
    click_on "Back"
  end

  test "updating a Age usu perfil" do
    visit age_usu_perfiles_url
    click_on "Edit", match: :first

    fill_in "Age usuario", with: @age_usu_perfil.age_usuario_id
    fill_in "App perfil", with: @age_usu_perfil.app_perfil_id
    click_on "Update Age usu perfil"

    assert_text "Age usu perfil was successfully updated"
    click_on "Back"
  end

  test "destroying a Age usu perfil" do
    visit age_usu_perfiles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age usu perfil was successfully destroyed"
  end
end
