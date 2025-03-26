require "application_system_test_case"

class HlpNotasTest < ApplicationSystemTestCase
  setup do
    @hlp_nota = hlp_notas(:one)
  end

  test "visiting the index" do
    visit hlp_notas_url
    assert_selector "h1", text: "Hlp notas"
  end

  test "should create hlp nota" do
    visit hlp_notas_url
    click_on "New hlp nota"

    fill_in "Hlp nota", with: @hlp_nota.hlp_nota
    fill_in "Orden", with: @hlp_nota.orden
    fill_in "Ownr", with: @hlp_nota.ownr_id
    fill_in "Ownr type", with: @hlp_nota.ownr_type
    fill_in "Referencia", with: @hlp_nota.referencia
    fill_in "Texto", with: @hlp_nota.texto
    click_on "Create Hlp nota"

    assert_text "Hlp nota was successfully created"
    click_on "Back"
  end

  test "should update Hlp nota" do
    visit hlp_nota_url(@hlp_nota)
    click_on "Edit this hlp nota", match: :first

    fill_in "Hlp nota", with: @hlp_nota.hlp_nota
    fill_in "Orden", with: @hlp_nota.orden
    fill_in "Ownr", with: @hlp_nota.ownr_id
    fill_in "Ownr type", with: @hlp_nota.ownr_type
    fill_in "Referencia", with: @hlp_nota.referencia
    fill_in "Texto", with: @hlp_nota.texto
    click_on "Update Hlp nota"

    assert_text "Hlp nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Hlp nota" do
    visit hlp_nota_url(@hlp_nota)
    click_on "Destroy this hlp nota", match: :first

    assert_text "Hlp nota was successfully destroyed"
  end
end
