require "application_system_test_case"

class TarFormulasTest < ApplicationSystemTestCase
  setup do
    @tar_formula = tar_formulas(:one)
  end

  test "visiting the index" do
    visit tar_formulas_url
    assert_selector "h1", text: "Tar Formulas"
  end

  test "creating a Tar formula" do
    visit tar_formulas_url
    click_on "New Tar Formula"

    fill_in "Error", with: @tar_formula.error
    fill_in "Mensaje", with: @tar_formula.mensaje
    fill_in "Orden", with: @tar_formula.orden
    fill_in "Tar formula", with: @tar_formula.tar_formula
    fill_in "Tar pago", with: @tar_formula.tar_pago_id
    click_on "Create Tar formula"

    assert_text "Tar formula was successfully created"
    click_on "Back"
  end

  test "updating a Tar formula" do
    visit tar_formulas_url
    click_on "Edit", match: :first

    fill_in "Error", with: @tar_formula.error
    fill_in "Mensaje", with: @tar_formula.mensaje
    fill_in "Orden", with: @tar_formula.orden
    fill_in "Tar formula", with: @tar_formula.tar_formula
    fill_in "Tar pago", with: @tar_formula.tar_pago_id
    click_on "Update Tar formula"

    assert_text "Tar formula was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar formula" do
    visit tar_formulas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar formula was successfully destroyed"
  end
end
