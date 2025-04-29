require "application_system_test_case"

class KrnReportesTest < ApplicationSystemTestCase
  setup do
    @krn_reporte = krn_reportes(:one)
  end

  test "visiting the index" do
    visit krn_reportes_url
    assert_selector "h1", text: "Krn reportes"
  end

  test "should create krn reporte" do
    visit krn_reportes_url
    click_on "New krn reporte"

    click_on "Create Krn reporte"

    assert_text "Krn reporte was successfully created"
    click_on "Back"
  end

  test "should update Krn reporte" do
    visit krn_reporte_url(@krn_reporte)
    click_on "Edit this krn reporte", match: :first

    click_on "Update Krn reporte"

    assert_text "Krn reporte was successfully updated"
    click_on "Back"
  end

  test "should destroy Krn reporte" do
    visit krn_reporte_url(@krn_reporte)
    click_on "Destroy this krn reporte", match: :first

    assert_text "Krn reporte was successfully destroyed"
  end
end
