require "application_system_test_case"

class CalFeriadosTest < ApplicationSystemTestCase
  setup do
    @cal_feriado = cal_feriados(:one)
  end

  test "visiting the index" do
    visit cal_feriados_url
    assert_selector "h1", text: "Cal Feriados"
  end

  test "creating a Cal feriado" do
    visit cal_feriados_url
    click_on "New Cal Feriado"

    fill_in "Cal annio", with: @cal_feriado.cal_annio_id
    fill_in "Cal fecha", with: @cal_feriado.cal_fecha
    fill_in "Descripcion", with: @cal_feriado.descripcion
    click_on "Create Cal feriado"

    assert_text "Cal feriado was successfully created"
    click_on "Back"
  end

  test "updating a Cal feriado" do
    visit cal_feriados_url
    click_on "Edit", match: :first

    fill_in "Cal annio", with: @cal_feriado.cal_annio_id
    fill_in "Cal fecha", with: @cal_feriado.cal_fecha
    fill_in "Descripcion", with: @cal_feriado.descripcion
    click_on "Update Cal feriado"

    assert_text "Cal feriado was successfully updated"
    click_on "Back"
  end

  test "destroying a Cal feriado" do
    visit cal_feriados_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cal feriado was successfully destroyed"
  end
end
