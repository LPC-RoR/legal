require "application_system_test_case"

class HlpPasosTest < ApplicationSystemTestCase
  setup do
    @hlp_paso = hlp_pasos(:one)
  end

  test "visiting the index" do
    visit hlp_pasos_url
    assert_selector "h1", text: "Hlp Pasos"
  end

  test "creating a Hlp paso" do
    visit hlp_pasos_url
    click_on "New Hlp Paso"

    fill_in "Detalle", with: @hlp_paso.detalle
    fill_in "Hlp tutorial", with: @hlp_paso.hlp_tutorial_id
    fill_in "Orden", with: @hlp_paso.orden
    fill_in "Paso", with: @hlp_paso.paso
    click_on "Create Hlp paso"

    assert_text "Hlp paso was successfully created"
    click_on "Back"
  end

  test "updating a Hlp paso" do
    visit hlp_pasos_url
    click_on "Edit", match: :first

    fill_in "Detalle", with: @hlp_paso.detalle
    fill_in "Hlp tutorial", with: @hlp_paso.hlp_tutorial_id
    fill_in "Orden", with: @hlp_paso.orden
    fill_in "Paso", with: @hlp_paso.paso
    click_on "Update Hlp paso"

    assert_text "Hlp paso was successfully updated"
    click_on "Back"
  end

  test "destroying a Hlp paso" do
    visit hlp_pasos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hlp paso was successfully destroyed"
  end
end
