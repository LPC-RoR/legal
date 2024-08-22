require "application_system_test_case"

class LglTramoEmpresasTest < ApplicationSystemTestCase
  setup do
    @lgl_tramo_empresa = lgl_tramo_empresas(:one)
  end

  test "visiting the index" do
    visit lgl_tramo_empresas_url
    assert_selector "h1", text: "Lgl tramo empresas"
  end

  test "should create lgl tramo empresa" do
    visit lgl_tramo_empresas_url
    click_on "New lgl tramo empresa"

    fill_in "Lgl tramo empresa", with: @lgl_tramo_empresa.lgl_tramo_empresa
    fill_in "Max", with: @lgl_tramo_empresa.max
    fill_in "Min", with: @lgl_tramo_empresa.min
    click_on "Create Lgl tramo empresa"

    assert_text "Lgl tramo empresa was successfully created"
    click_on "Back"
  end

  test "should update Lgl tramo empresa" do
    visit lgl_tramo_empresa_url(@lgl_tramo_empresa)
    click_on "Edit this lgl tramo empresa", match: :first

    fill_in "Lgl tramo empresa", with: @lgl_tramo_empresa.lgl_tramo_empresa
    fill_in "Max", with: @lgl_tramo_empresa.max
    fill_in "Min", with: @lgl_tramo_empresa.min
    click_on "Update Lgl tramo empresa"

    assert_text "Lgl tramo empresa was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl tramo empresa" do
    visit lgl_tramo_empresa_url(@lgl_tramo_empresa)
    click_on "Destroy this lgl tramo empresa", match: :first

    assert_text "Lgl tramo empresa was successfully destroyed"
  end
end
