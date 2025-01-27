require "application_system_test_case"

class TarTipoVariablesTest < ApplicationSystemTestCase
  setup do
    @tar_tipo_variable = tar_tipo_variables(:one)
  end

  test "visiting the index" do
    visit tar_tipo_variables_url
    assert_selector "h1", text: "Tar tipo variables"
  end

  test "should create tar tipo variable" do
    visit tar_tipo_variables_url
    click_on "New tar tipo variable"

    fill_in "Tar tarifa", with: @tar_tipo_variable.tar_tarifa_id
    fill_in "Tipo causa", with: @tar_tipo_variable.tipo_causa_id
    fill_in "Variable tipo causa", with: @tar_tipo_variable.variable_tipo_causa
    click_on "Create Tar tipo variable"

    assert_text "Tar tipo variable was successfully created"
    click_on "Back"
  end

  test "should update Tar tipo variable" do
    visit tar_tipo_variable_url(@tar_tipo_variable)
    click_on "Edit this tar tipo variable", match: :first

    fill_in "Tar tarifa", with: @tar_tipo_variable.tar_tarifa_id
    fill_in "Tipo causa", with: @tar_tipo_variable.tipo_causa_id
    fill_in "Variable tipo causa", with: @tar_tipo_variable.variable_tipo_causa
    click_on "Update Tar tipo variable"

    assert_text "Tar tipo variable was successfully updated"
    click_on "Back"
  end

  test "should destroy Tar tipo variable" do
    visit tar_tipo_variable_url(@tar_tipo_variable)
    click_on "Destroy this tar tipo variable", match: :first

    assert_text "Tar tipo variable was successfully destroyed"
  end
end
