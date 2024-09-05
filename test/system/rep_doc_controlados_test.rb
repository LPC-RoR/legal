require "application_system_test_case"

class RepDocControladosTest < ApplicationSystemTestCase
  setup do
    @rep_doc_controlado = rep_doc_controlados(:one)
  end

  test "visiting the index" do
    visit rep_doc_controlados_url
    assert_selector "h1", text: "Rep doc controlados"
  end

  test "should create rep doc controlado" do
    visit rep_doc_controlados_url
    click_on "New rep doc controlado"

    fill_in "Archivo", with: @rep_doc_controlado.archivo
    fill_in "Control", with: @rep_doc_controlado.control
    fill_in "Orden", with: @rep_doc_controlado.orden
    fill_in "Ownr", with: @rep_doc_controlado.ownr_id
    fill_in "Ownr type", with: @rep_doc_controlado.ownr_type
    fill_in "Rep doc controlado", with: @rep_doc_controlado.rep_doc_controlado
    fill_in "Tipo", with: @rep_doc_controlado.tipo
    click_on "Create Rep doc controlado"

    assert_text "Rep doc controlado was successfully created"
    click_on "Back"
  end

  test "should update Rep doc controlado" do
    visit rep_doc_controlado_url(@rep_doc_controlado)
    click_on "Edit this rep doc controlado", match: :first

    fill_in "Archivo", with: @rep_doc_controlado.archivo
    fill_in "Control", with: @rep_doc_controlado.control
    fill_in "Orden", with: @rep_doc_controlado.orden
    fill_in "Ownr", with: @rep_doc_controlado.ownr_id
    fill_in "Ownr type", with: @rep_doc_controlado.ownr_type
    fill_in "Rep doc controlado", with: @rep_doc_controlado.rep_doc_controlado
    fill_in "Tipo", with: @rep_doc_controlado.tipo
    click_on "Update Rep doc controlado"

    assert_text "Rep doc controlado was successfully updated"
    click_on "Back"
  end

  test "should destroy Rep doc controlado" do
    visit rep_doc_controlado_url(@rep_doc_controlado)
    click_on "Destroy this rep doc controlado", match: :first

    assert_text "Rep doc controlado was successfully destroyed"
  end
end
