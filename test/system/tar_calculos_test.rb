require "application_system_test_case"

class TarCalculosTest < ApplicationSystemTestCase
  setup do
    @tar_calculo = tar_calculos(:one)
  end

  test "visiting the index" do
    visit tar_calculos_url
    assert_selector "h1", text: "Tar Calculos"
  end

  test "creating a Tar calculo" do
    visit tar_calculos_url
    click_on "New Tar Calculo"

    fill_in "Clnt", with: @tar_calculo.clnt_id
    fill_in "Cuantia", with: @tar_calculo.cuantia
    fill_in "Glosa", with: @tar_calculo.glosa
    fill_in "Moneda", with: @tar_calculo.moneda
    fill_in "Monto", with: @tar_calculo.monto
    fill_in "Ownr clss", with: @tar_calculo.ownr_clss
    fill_in "Ownr", with: @tar_calculo.ownr_id
    fill_in "Tar pago", with: @tar_calculo.tar_pago_id
    click_on "Create Tar calculo"

    assert_text "Tar calculo was successfully created"
    click_on "Back"
  end

  test "updating a Tar calculo" do
    visit tar_calculos_url
    click_on "Edit", match: :first

    fill_in "Clnt", with: @tar_calculo.clnt_id
    fill_in "Cuantia", with: @tar_calculo.cuantia
    fill_in "Glosa", with: @tar_calculo.glosa
    fill_in "Moneda", with: @tar_calculo.moneda
    fill_in "Monto", with: @tar_calculo.monto
    fill_in "Ownr clss", with: @tar_calculo.ownr_clss
    fill_in "Ownr", with: @tar_calculo.ownr_id
    fill_in "Tar pago", with: @tar_calculo.tar_pago_id
    click_on "Update Tar calculo"

    assert_text "Tar calculo was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar calculo" do
    visit tar_calculos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar calculo was successfully destroyed"
  end
end
