require "application_system_test_case"

class AgeAntecedentesTest < ApplicationSystemTestCase
  setup do
    @age_antecedente = age_antecedentes(:one)
  end

  test "visiting the index" do
    visit age_antecedentes_url
    assert_selector "h1", text: "Age Antecedentes"
  end

  test "creating a Age antecedente" do
    visit age_antecedentes_url
    click_on "New Age Antecedente"

    fill_in "Age actividad", with: @age_antecedente.age_actividad_id
    fill_in "Age antecedente", with: @age_antecedente.age_antecedente
    fill_in "Orden", with: @age_antecedente.orden
    click_on "Create Age antecedente"

    assert_text "Age antecedente was successfully created"
    click_on "Back"
  end

  test "updating a Age antecedente" do
    visit age_antecedentes_url
    click_on "Edit", match: :first

    fill_in "Age actividad", with: @age_antecedente.age_actividad_id
    fill_in "Age antecedente", with: @age_antecedente.age_antecedente
    fill_in "Orden", with: @age_antecedente.orden
    click_on "Update Age antecedente"

    assert_text "Age antecedente was successfully updated"
    click_on "Back"
  end

  test "destroying a Age antecedente" do
    visit age_antecedentes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Age antecedente was successfully destroyed"
  end
end
