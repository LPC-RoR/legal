require "application_system_test_case"

class AgeActividadesTest < ApplicationSystemTestCase
  setup do
    @age_actividad = age_actividades(:one)
  end

  test "visiting the index" do
    visit age_actividades_url
    assert_selector "h1", text: "Age Actividades"
  end

  test "creating a Age actividad" do
    visit age_actividades_url
    click_on "New Age Actividad"

    fill_in "Age actividad", with: @age_actividad.age_actividad
    fill_in "App perfil", with: @age_actividad.app_perfil_id
    fill_in "Estado", with: @age_actividad.estado
    fill_in "Owner class", with: @age_actividad.owner_class
    fill_in "Owner", with: @age_actividad.owner_id
    fill_in "Tipo", with: @age_actividad.tipo
    click_on "Create Age actividad"

    assert_text "Age actividad was successfully created"
    click_on "Back"
  end

  test "updating a Age actividad" do
    visit age_actividades_url
    click_on "Edit", match: :first

    fill_in "Age actividad", with: @age_actividad.age_actividad
    fill_in "App perfil", with: @age_actividad.app_perfil_id
    fill_in "Estado", with: @age_actividad.estado
    fill_in "Owner class", with: @age_actividad.owner_class
    fill_in "Owner", with: @age_actividad.owner_id
    fill_in "Tipo", with: @age_actividad.tipo
    click_on "Update Age actividad"

    assert_text "Age actividad was successfully updated"
    click_on "Back"
  end

  test "destroying a Age actividad" do
    visit age_actividades_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age actividad was successfully destroyed"
  end
end
