require "application_system_test_case"

class DocPlanillasTest < ApplicationSystemTestCase
  setup do
    @doc_planilla = doc_planillas(:one)
  end

  test "visiting the index" do
    visit doc_planillas_url
    assert_selector "h1", text: "Doc planillas"
  end

  test "should create doc planilla" do
    visit doc_planillas_url
    click_on "New doc planilla"

    fill_in "Nombre original", with: @doc_planilla.nombre_original
    click_on "Create Doc planilla"

    assert_text "Doc planilla was successfully created"
    click_on "Back"
  end

  test "should update Doc planilla" do
    visit doc_planilla_url(@doc_planilla)
    click_on "Edit this doc planilla", match: :first

    fill_in "Nombre original", with: @doc_planilla.nombre_original
    click_on "Update Doc planilla"

    assert_text "Doc planilla was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc planilla" do
    visit doc_planilla_url(@doc_planilla)
    click_on "Destroy this doc planilla", match: :first

    assert_text "Doc planilla was successfully destroyed"
  end
end
