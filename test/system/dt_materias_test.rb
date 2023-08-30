require "application_system_test_case"

class DtMateriasTest < ApplicationSystemTestCase
  setup do
    @dt_materia = dt_materias(:one)
  end

  test "visiting the index" do
    visit dt_materias_url
    assert_selector "h1", text: "Dt Materias"
  end

  test "creating a Dt materia" do
    visit dt_materias_url
    click_on "New Dt Materia"

    fill_in "Capitulo", with: @dt_materia.capitulo
    fill_in "Dt materia", with: @dt_materia.dt_materia
    click_on "Create Dt materia"

    assert_text "Dt materia was successfully created"
    click_on "Back"
  end

  test "updating a Dt materia" do
    visit dt_materias_url
    click_on "Edit", match: :first

    fill_in "Capitulo", with: @dt_materia.capitulo
    fill_in "Dt materia", with: @dt_materia.dt_materia
    click_on "Update Dt materia"

    assert_text "Dt materia was successfully updated"
    click_on "Back"
  end

  test "destroying a Dt materia" do
    visit dt_materias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Dt materia was successfully destroyed"
  end
end
