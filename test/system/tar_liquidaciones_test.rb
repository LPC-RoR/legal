require "application_system_test_case"

class TarLiquidacionesTest < ApplicationSystemTestCase
  setup do
    @tar_liquidacion = tar_liquidaciones(:one)
  end

  test "visiting the index" do
    visit tar_liquidaciones_url
    assert_selector "h1", text: "Tar Liquidaciones"
  end

  test "creating a Tar liquidacion" do
    visit tar_liquidaciones_url
    click_on "New Tar Liquidacion"

    fill_in "Liquidacion", with: @tar_liquidacion.liquidacion
    fill_in "Owner class", with: @tar_liquidacion.owner_class
    fill_in "Owner", with: @tar_liquidacion.owner_id
    click_on "Create Tar liquidacion"

    assert_text "Tar liquidacion was successfully created"
    click_on "Back"
  end

  test "updating a Tar liquidacion" do
    visit tar_liquidaciones_url
    click_on "Edit", match: :first

    fill_in "Liquidacion", with: @tar_liquidacion.liquidacion
    fill_in "Owner class", with: @tar_liquidacion.owner_class
    fill_in "Owner", with: @tar_liquidacion.owner_id
    click_on "Update Tar liquidacion"

    assert_text "Tar liquidacion was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar liquidacion" do
    visit tar_liquidaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar liquidacion was successfully destroyed"
  end
end
