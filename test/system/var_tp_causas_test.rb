require "application_system_test_case"

class VarTpCausasTest < ApplicationSystemTestCase
  setup do
    @var_tp_causa = var_tp_causas(:one)
  end

  test "visiting the index" do
    visit var_tp_causas_url
    assert_selector "h1", text: "Var Tp Causas"
  end

  test "creating a Var tp causa" do
    visit var_tp_causas_url
    click_on "New Var Tp Causa"

    fill_in "Tipo causa", with: @var_tp_causa.tipo_causa_id
    fill_in "Variable", with: @var_tp_causa.variable_id
    click_on "Create Var tp causa"

    assert_text "Var tp causa was successfully created"
    click_on "Back"
  end

  test "updating a Var tp causa" do
    visit var_tp_causas_url
    click_on "Edit", match: :first

    fill_in "Tipo causa", with: @var_tp_causa.tipo_causa_id
    fill_in "Variable", with: @var_tp_causa.variable_id
    click_on "Update Var tp causa"

    assert_text "Var tp causa was successfully updated"
    click_on "Back"
  end

  test "destroying a Var tp causa" do
    visit var_tp_causas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Var tp causa was successfully destroyed"
  end
end
