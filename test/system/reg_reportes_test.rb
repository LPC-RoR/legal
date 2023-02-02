require "application_system_test_case"

class RegReportesTest < ApplicationSystemTestCase
  setup do
    @reg_reporte = reg_reportes(:one)
  end

  test "visiting the index" do
    visit reg_reportes_url
    assert_selector "h1", text: "Reg Reportes"
  end

  test "creating a Reg reporte" do
    visit reg_reportes_url
    click_on "New Reg Reporte"

    fill_in "Clave", with: @reg_reporte.clave
    click_on "Create Reg reporte"

    assert_text "Reg reporte was successfully created"
    click_on "Back"
  end

  test "updating a Reg reporte" do
    visit reg_reportes_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @reg_reporte.clave
    click_on "Update Reg reporte"

    assert_text "Reg reporte was successfully updated"
    click_on "Back"
  end

  test "destroying a Reg reporte" do
    visit reg_reportes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reg reporte was successfully destroyed"
  end
end
