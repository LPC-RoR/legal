require "application_system_test_case"

class HlpAyudasTest < ApplicationSystemTestCase
  setup do
    @hlp_ayuda = hlp_ayudas(:one)
  end

  test "visiting the index" do
    visit hlp_ayudas_url
    assert_selector "h1", text: "Hlp ayudas"
  end

  test "should create hlp ayuda" do
    visit hlp_ayudas_url
    click_on "New hlp ayuda"

    fill_in "Hlp ayuda", with: @hlp_ayuda.hlp_ayuda
    fill_in "Ownr", with: @hlp_ayuda.ownr_id
    fill_in "Ownr type", with: @hlp_ayuda.ownr_type
    fill_in "Referencia", with: @hlp_ayuda.referencia
    fill_in "Texto", with: @hlp_ayuda.texto
    click_on "Create Hlp ayuda"

    assert_text "Hlp ayuda was successfully created"
    click_on "Back"
  end

  test "should update Hlp ayuda" do
    visit hlp_ayuda_url(@hlp_ayuda)
    click_on "Edit this hlp ayuda", match: :first

    fill_in "Hlp ayuda", with: @hlp_ayuda.hlp_ayuda
    fill_in "Ownr", with: @hlp_ayuda.ownr_id
    fill_in "Ownr type", with: @hlp_ayuda.ownr_type
    fill_in "Referencia", with: @hlp_ayuda.referencia
    fill_in "Texto", with: @hlp_ayuda.texto
    click_on "Update Hlp ayuda"

    assert_text "Hlp ayuda was successfully updated"
    click_on "Back"
  end

  test "should destroy Hlp ayuda" do
    visit hlp_ayuda_url(@hlp_ayuda)
    click_on "Destroy this hlp ayuda", match: :first

    assert_text "Hlp ayuda was successfully destroyed"
  end
end
