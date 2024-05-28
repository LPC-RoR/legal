require "application_system_test_case"

class VarClisTest < ApplicationSystemTestCase
  setup do
    @var_cli = var_clis(:one)
  end

  test "visiting the index" do
    visit var_clis_url
    assert_selector "h1", text: "Var Clis"
  end

  test "creating a Var cli" do
    visit var_clis_url
    click_on "New Var Cli"

    fill_in "Cliente", with: @var_cli.cliente_id
    fill_in "Variable", with: @var_cli.variable_id
    click_on "Create Var cli"

    assert_text "Var cli was successfully created"
    click_on "Back"
  end

  test "updating a Var cli" do
    visit var_clis_url
    click_on "Edit", match: :first

    fill_in "Cliente", with: @var_cli.cliente_id
    fill_in "Variable", with: @var_cli.variable_id
    click_on "Update Var cli"

    assert_text "Var cli was successfully updated"
    click_on "Back"
  end

  test "destroying a Var cli" do
    visit var_clis_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Var cli was successfully destroyed"
  end
end
