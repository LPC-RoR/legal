require "application_system_test_case"

class KSesionesTest < ApplicationSystemTestCase
  setup do
    @k_sesion = k_sesiones(:one)
  end

  test "visiting the index" do
    visit k_sesiones_url
    assert_selector "h1", text: "K sesiones"
  end

  test "should create k sesion" do
    visit k_sesiones_url
    click_on "New k sesion"

    fill_in "Fecha", with: @k_sesion.fecha
    fill_in "Sesion", with: @k_sesion.sesion
    click_on "Create K sesion"

    assert_text "K sesion was successfully created"
    click_on "Back"
  end

  test "should update K sesion" do
    visit k_sesion_url(@k_sesion)
    click_on "Edit this k sesion", match: :first

    fill_in "Fecha", with: @k_sesion.fecha
    fill_in "Sesion", with: @k_sesion.sesion
    click_on "Update K sesion"

    assert_text "K sesion was successfully updated"
    click_on "Back"
  end

  test "should destroy K sesion" do
    visit k_sesion_url(@k_sesion)
    click_on "Destroy this k sesion", match: :first

    assert_text "K sesion was successfully destroyed"
  end
end
