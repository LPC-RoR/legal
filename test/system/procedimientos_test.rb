require "application_system_test_case"

class ProcedimientosTest < ApplicationSystemTestCase
  setup do
    @procedimiento = procedimientos(:one)
  end

  test "visiting the index" do
    visit procedimientos_url
    assert_selector "h1", text: "Procedimientos"
  end

  test "should create procedimiento" do
    visit procedimientos_url
    click_on "New procedimiento"

    fill_in "Procedimiento", with: @procedimiento.procedimiento
    fill_in "Tipo procedimiento", with: @procedimiento.tipo_procedimiento_id
    click_on "Create Procedimiento"

    assert_text "Procedimiento was successfully created"
    click_on "Back"
  end

  test "should update Procedimiento" do
    visit procedimiento_url(@procedimiento)
    click_on "Edit this procedimiento", match: :first

    fill_in "Procedimiento", with: @procedimiento.procedimiento
    fill_in "Tipo procedimiento", with: @procedimiento.tipo_procedimiento_id
    click_on "Update Procedimiento"

    assert_text "Procedimiento was successfully updated"
    click_on "Back"
  end

  test "should destroy Procedimiento" do
    visit procedimiento_url(@procedimiento)
    click_on "Destroy this procedimiento", match: :first

    assert_text "Procedimiento was successfully destroyed"
  end
end
