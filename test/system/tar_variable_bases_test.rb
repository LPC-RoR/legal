require "application_system_test_case"

class TarVariableBasesTest < ApplicationSystemTestCase
  setup do
    @tar_variable_bas = tar_variable_bases(:one)
  end

  test "visiting the index" do
    visit tar_variable_bases_url
    assert_selector "h1", text: "Tar Variable Bases"
  end

  test "creating a Tar variable base" do
    visit tar_variable_bases_url
    click_on "New Tar Variable Base"

    fill_in "Tar base variable", with: @tar_variable_bas.tar_base_variable
    fill_in "Tar tarifa", with: @tar_variable_bas.tar_tarifa_id
    fill_in "Tipo causa", with: @tar_variable_bas.tipo_causa_id
    click_on "Create Tar variable base"

    assert_text "Tar variable base was successfully created"
    click_on "Back"
  end

  test "updating a Tar variable base" do
    visit tar_variable_bases_url
    click_on "Edit", match: :first

    fill_in "Tar base variable", with: @tar_variable_bas.tar_base_variable
    fill_in "Tar tarifa", with: @tar_variable_bas.tar_tarifa_id
    fill_in "Tipo causa", with: @tar_variable_bas.tipo_causa_id
    click_on "Update Tar variable base"

    assert_text "Tar variable base was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar variable base" do
    visit tar_variable_bases_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar variable base was successfully destroyed"
  end
end
