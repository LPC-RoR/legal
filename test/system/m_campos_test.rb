require "application_system_test_case"

class MCamposTest < ApplicationSystemTestCase
  setup do
    @m_campo = m_campos(:one)
  end

  test "visiting the index" do
    visit m_campos_url
    assert_selector "h1", text: "M Campos"
  end

  test "creating a M campo" do
    visit m_campos_url
    click_on "New M Campo"

    fill_in "M campo", with: @m_campo.m_campo
    fill_in "M conciliacion", with: @m_campo.m_conciliacion_id
    fill_in "Valor", with: @m_campo.valor
    click_on "Create M campo"

    assert_text "M campo was successfully created"
    click_on "Back"
  end

  test "updating a M campo" do
    visit m_campos_url
    click_on "Edit", match: :first

    fill_in "M campo", with: @m_campo.m_campo
    fill_in "M conciliacion", with: @m_campo.m_conciliacion_id
    fill_in "Valor", with: @m_campo.valor
    click_on "Update M campo"

    assert_text "M campo was successfully updated"
    click_on "Back"
  end

  test "destroying a M campo" do
    visit m_campos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M campo was successfully destroyed"
  end
end
