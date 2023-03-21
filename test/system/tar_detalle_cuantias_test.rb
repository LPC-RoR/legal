require "application_system_test_case"

class TarDetalleCuantiasTest < ApplicationSystemTestCase
  setup do
    @tar_detalle_cuantia = tar_detalle_cuantias(:one)
  end

  test "visiting the index" do
    visit tar_detalle_cuantias_url
    assert_selector "h1", text: "Tar Detalle Cuantias"
  end

  test "creating a Tar detalle cuantia" do
    visit tar_detalle_cuantias_url
    click_on "New Tar Detalle Cuantia"

    fill_in "Tar detalle cuantia", with: @tar_detalle_cuantia.tar_detalle_cuantia
    click_on "Create Tar detalle cuantia"

    assert_text "Tar detalle cuantia was successfully created"
    click_on "Back"
  end

  test "updating a Tar detalle cuantia" do
    visit tar_detalle_cuantias_url
    click_on "Edit", match: :first

    fill_in "Tar detalle cuantia", with: @tar_detalle_cuantia.tar_detalle_cuantia
    click_on "Update Tar detalle cuantia"

    assert_text "Tar detalle cuantia was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar detalle cuantia" do
    visit tar_detalle_cuantias_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar detalle cuantia was successfully destroyed"
  end
end
