require "application_system_test_case"

class SlidesTest < ApplicationSystemTestCase
  setup do
    @slid = slides(:one)
  end

  test "visiting the index" do
    visit slides_url
    assert_selector "h1", text: "Slides"
  end

  test "should create slide" do
    visit slides_url
    click_on "New slide"

    check "Desactivar" if @slid.desactivar
    fill_in "Nombre", with: @slid.nombre
    fill_in "Orden", with: @slid.orden
    fill_in "Txt", with: @slid.txt
    click_on "Create Slide"

    assert_text "Slide was successfully created"
    click_on "Back"
  end

  test "should update Slide" do
    visit slid_url(@slid)
    click_on "Edit this slide", match: :first

    check "Desactivar" if @slid.desactivar
    fill_in "Nombre", with: @slid.nombre
    fill_in "Orden", with: @slid.orden
    fill_in "Txt", with: @slid.txt
    click_on "Update Slide"

    assert_text "Slide was successfully updated"
    click_on "Back"
  end

  test "should destroy Slide" do
    visit slid_url(@slid)
    click_on "Destroy this slide", match: :first

    assert_text "Slide was successfully destroyed"
  end
end
