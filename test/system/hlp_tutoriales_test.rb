require "application_system_test_case"

class HlpTutorialesTest < ApplicationSystemTestCase
  setup do
    @hlp_tutorial = hlp_tutoriales(:one)
  end

  test "visiting the index" do
    visit hlp_tutoriales_url
    assert_selector "h1", text: "Hlp Tutoriales"
  end

  test "creating a Hlp tutorial" do
    visit hlp_tutoriales_url
    click_on "New Hlp Tutorial"

    fill_in "Clave", with: @hlp_tutorial.clave
    fill_in "Detalle", with: @hlp_tutorial.detalle
    fill_in "Tutorial", with: @hlp_tutorial.tutorial
    click_on "Create Hlp tutorial"

    assert_text "Hlp tutorial was successfully created"
    click_on "Back"
  end

  test "updating a Hlp tutorial" do
    visit hlp_tutoriales_url
    click_on "Edit", match: :first

    fill_in "Clave", with: @hlp_tutorial.clave
    fill_in "Detalle", with: @hlp_tutorial.detalle
    fill_in "Tutorial", with: @hlp_tutorial.tutorial
    click_on "Update Hlp tutorial"

    assert_text "Hlp tutorial was successfully updated"
    click_on "Back"
  end

  test "destroying a Hlp tutorial" do
    visit hlp_tutoriales_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hlp tutorial was successfully destroyed"
  end
end
