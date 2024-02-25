require "application_system_test_case"

class TarDetCuantiaControlesTest < ApplicationSystemTestCase
  setup do
    @tar_det_cuantia_control = tar_det_cuantia_controles(:one)
  end

  test "visiting the index" do
    visit tar_det_cuantia_controles_url
    assert_selector "h1", text: "Tar Det Cuantia Controles"
  end

  test "creating a Tar det cuantia control" do
    visit tar_det_cuantia_controles_url
    click_on "New Tar Det Cuantia Control"

    fill_in "Control documento", with: @tar_det_cuantia_control.control_documento_id
    fill_in "Tar detalle cuantia", with: @tar_det_cuantia_control.tar_detalle_cuantia_id
    click_on "Create Tar det cuantia control"

    assert_text "Tar det cuantia control was successfully created"
    click_on "Back"
  end

  test "updating a Tar det cuantia control" do
    visit tar_det_cuantia_controles_url
    click_on "Edit", match: :first

    fill_in "Control documento", with: @tar_det_cuantia_control.control_documento_id
    fill_in "Tar detalle cuantia", with: @tar_det_cuantia_control.tar_detalle_cuantia_id
    click_on "Update Tar det cuantia control"

    assert_text "Tar det cuantia control was successfully updated"
    click_on "Back"
  end

  test "destroying a Tar det cuantia control" do
    visit tar_det_cuantia_controles_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tar det cuantia control was successfully destroyed"
  end
end
