require "application_system_test_case"

class DtTramosTest < ApplicationSystemTestCase
  setup do
    @dt_tramo = dt_tramos(:one)
  end

  test "visiting the index" do
    visit dt_tramos_url
    assert_selector "h1", text: "Dt tramos"
  end

  test "should create dt tramo" do
    visit dt_tramos_url
    click_on "New dt tramo"

    fill_in "Dt tramo", with: @dt_tramo.dt_tramo
    fill_in "Max", with: @dt_tramo.max
    fill_in "Min", with: @dt_tramo.min
    fill_in "Orden", with: @dt_tramo.orden
    click_on "Create Dt tramo"

    assert_text "Dt tramo was successfully created"
    click_on "Back"
  end

  test "should update Dt tramo" do
    visit dt_tramo_url(@dt_tramo)
    click_on "Edit this dt tramo", match: :first

    fill_in "Dt tramo", with: @dt_tramo.dt_tramo
    fill_in "Max", with: @dt_tramo.max
    fill_in "Min", with: @dt_tramo.min
    fill_in "Orden", with: @dt_tramo.orden
    click_on "Update Dt tramo"

    assert_text "Dt tramo was successfully updated"
    click_on "Back"
  end

  test "should destroy Dt tramo" do
    visit dt_tramo_url(@dt_tramo)
    click_on "Destroy this dt tramo", match: :first

    assert_text "Dt tramo was successfully destroyed"
  end
end
