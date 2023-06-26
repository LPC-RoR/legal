require "application_system_test_case"

class MConciliacionesTest < ApplicationSystemTestCase
  setup do
    @m_conciliacion = m_conciliaciones(:one)
  end

  test "visiting the index" do
    visit m_conciliaciones_url
    assert_selector "h1", text: "M Conciliaciones"
  end

  test "creating a M conciliacion" do
    visit m_conciliaciones_url
    click_on "New M Conciliacion"

    fill_in "M conciliacion", with: @m_conciliacion.m_conciliacion
    click_on "Create M conciliacion"

    assert_text "M conciliacion was successfully created"
    click_on "Back"
  end

  test "updating a M conciliacion" do
    visit m_conciliaciones_url
    click_on "Edit", match: :first

    fill_in "M conciliacion", with: @m_conciliacion.m_conciliacion
    click_on "Update M conciliacion"

    assert_text "M conciliacion was successfully updated"
    click_on "Back"
  end

  test "destroying a M conciliacion" do
    visit m_conciliaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M conciliacion was successfully destroyed"
  end
end
