require "application_system_test_case"

class AgeUsuariosTest < ApplicationSystemTestCase
  setup do
    @age_usuario = age_usuarios(:one)
  end

  test "visiting the index" do
    visit age_usuarios_url
    assert_selector "h1", text: "Age Usuarios"
  end

  test "creating a Age usuario" do
    visit age_usuarios_url
    click_on "New Age Usuario"

    fill_in "Age usuario", with: @age_usuario.age_usuario
    fill_in "Owner class", with: @age_usuario.owner_class
    fill_in "Owner", with: @age_usuario.owner_id
    click_on "Create Age usuario"

    assert_text "Age usuario was successfully created"
    click_on "Back"
  end

  test "updating a Age usuario" do
    visit age_usuarios_url
    click_on "Edit", match: :first

    fill_in "Age usuario", with: @age_usuario.age_usuario
    fill_in "Owner class", with: @age_usuario.owner_class
    fill_in "Owner", with: @age_usuario.owner_id
    click_on "Update Age usuario"

    assert_text "Age usuario was successfully updated"
    click_on "Back"
  end

  test "destroying a Age usuario" do
    visit age_usuarios_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age usuario was successfully destroyed"
  end
end
