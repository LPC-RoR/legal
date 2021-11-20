require "application_system_test_case"

class TarTarifasTest < ApplicationSystemTestCase
  setup do
    @tar_tarifa = tar_tarifas(:one)
  end

  test "visiting the index" do
    visit tar_tarifas_url
    assert_selector "h1", text: "Tar Tarifas"
  end

  test "creating a Tar tarifa" do
    visit tar_tarifas_url
    click_on "New Tar Tarifa"

    fill_in "Estado", with: @tar_tarifa.estado
    fill_in "Owner class", with: @tar_tarifa.owner_class
    fill_in "Owner", with: @tar_tarifa.owner_id
    fill_in "Tarifa", with: @tar_tarifa.tarifa
    click_on "Create Tar tarifa"

    assert_text "Tar tarifa was successfully created"
    click_on "Back"
  end

  test "updating a Tar tarifa" do
    visit tar_tarifas_url
    click_on "Edit", match: :first

    fill_in "Estado", with: @tar_tarifa.estado
    fill_in "Owner class", with: @tar_tarifa.owner_class
    fill_in "Owner", with: @tar_tarifa.owner_id
    fill_in "Tarifa", with: @tar_tarifa.tarifa
    click_on "Update Tar tarifa"

    assert_text "Tar tarifa was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar tarifa" do
    visit tar_tarifas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar tarifa was successfully destroyed"
  end
end
