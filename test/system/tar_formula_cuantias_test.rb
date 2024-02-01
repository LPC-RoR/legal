require "application_system_test_case"

class TarFormulaCuantiasTest < ApplicationSystemTestCase
  setup do
    @tar_formula_cuantia = tar_formula_cuantias(:one)
  end

  test "visiting the index" do
    visit tar_formula_cuantias_url
    assert_selector "h1", text: "Tar Formula Cuantias"
  end

  test "creating a Tar formula cuantia" do
    visit tar_formula_cuantias_url
    click_on "New Tar Formula Cuantia"

    fill_in "Tar detalle cuantia", with: @tar_formula_cuantia.tar_detalle_cuantia
    fill_in "Tar formula cuantia", with: @tar_formula_cuantia.tar_formula_cuantia
    fill_in "Tar tarifa", with: @tar_formula_cuantia.tar_tarifa_id
    click_on "Create Tar formula cuantia"

    assert_text "Tar formula cuantia was successfully created"
    click_on "Back"
  end

  test "updating a Tar formula cuantia" do
    visit tar_formula_cuantias_url
    click_on "Edit", match: :first

    fill_in "Tar detalle cuantia", with: @tar_formula_cuantia.tar_detalle_cuantia
    fill_in "Tar formula cuantia", with: @tar_formula_cuantia.tar_formula_cuantia
    fill_in "Tar tarifa", with: @tar_formula_cuantia.tar_tarifa_id
    click_on "Update Tar formula cuantia"

    assert_text "Tar formula cuantia was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar formula cuantia" do
    visit tar_formula_cuantias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar formula cuantia was successfully destroyed"
  end
end
