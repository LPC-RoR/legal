require "application_system_test_case"

class CtrPasosTest < ApplicationSystemTestCase
  setup do
    @ctr_paso = ctr_pasos(:one)
  end

  test "visiting the index" do
    visit ctr_pasos_url
    assert_selector "h1", text: "Ctr pasos"
  end

  test "should create ctr paso" do
    visit ctr_pasos_url
    click_on "New ctr paso"

    fill_in "Codigo", with: @ctr_paso.codigo
    fill_in "Glosa", with: @ctr_paso.glosa
    fill_in "Orden", with: @ctr_paso.orden
    check "Rght" if @ctr_paso.rght
    fill_in "Tarea", with: @ctr_paso.tarea_id
    click_on "Create Ctr paso"

    assert_text "Ctr paso was successfully created"
    click_on "Back"
  end

  test "should update Ctr paso" do
    visit ctr_paso_url(@ctr_paso)
    click_on "Edit this ctr paso", match: :first

    fill_in "Codigo", with: @ctr_paso.codigo
    fill_in "Glosa", with: @ctr_paso.glosa
    fill_in "Orden", with: @ctr_paso.orden
    check "Rght" if @ctr_paso.rght
    fill_in "Tarea", with: @ctr_paso.tarea_id
    click_on "Update Ctr paso"

    assert_text "Ctr paso was successfully updated"
    click_on "Back"
  end

  test "should destroy Ctr paso" do
    visit ctr_paso_url(@ctr_paso)
    click_on "Destroy this ctr paso", match: :first

    assert_text "Ctr paso was successfully destroyed"
  end
end
