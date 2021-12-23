require "application_system_test_case"

class TarVariablesTest < ApplicationSystemTestCase
  setup do
    @tar_variable = tar_variables(:one)
  end

  test "visiting the index" do
    visit tar_variables_url
    assert_selector "h1", text: "Tar Variables"
  end

  test "creating a Tar variable" do
    visit tar_variables_url
    click_on "New Tar Variable"

    fill_in "Owner class", with: @tar_variable.owner_class
    fill_in "Owner", with: @tar_variable.owner_id
    fill_in "Porcentaje", with: @tar_variable.porcentaje
    fill_in "Variable", with: @tar_variable.variable
    click_on "Create Tar variable"

    assert_text "Tar variable was successfully created"
    click_on "Back"
  end

  test "updating a Tar variable" do
    visit tar_variables_url
    click_on "Edit", match: :first

    fill_in "Owner class", with: @tar_variable.owner_class
    fill_in "Owner", with: @tar_variable.owner_id
    fill_in "Porcentaje", with: @tar_variable.porcentaje
    fill_in "Variable", with: @tar_variable.variable
    click_on "Update Tar variable"

    assert_text "Tar variable was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar variable" do
    visit tar_variables_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar variable was successfully destroyed"
  end
end
