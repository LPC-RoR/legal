require "application_system_test_case"

class HmNotasTest < ApplicationSystemTestCase
  setup do
    @hm_nota = hm_notas(:one)
  end

  test "visiting the index" do
    visit hm_notas_url
    assert_selector "h1", text: "Hm notas"
  end

  test "should create hm nota" do
    visit hm_notas_url
    click_on "New hm nota"

    fill_in "Hm nota", with: @hm_nota.hm_nota
    fill_in "Hm parrafo", with: @hm_nota.hm_parrafo_id
    fill_in "Orden", with: @hm_nota.orden
    click_on "Create Hm nota"

    assert_text "Hm nota was successfully created"
    click_on "Back"
  end

  test "should update Hm nota" do
    visit hm_nota_url(@hm_nota)
    click_on "Edit this hm nota", match: :first

    fill_in "Hm nota", with: @hm_nota.hm_nota
    fill_in "Hm parrafo", with: @hm_nota.hm_parrafo_id
    fill_in "Orden", with: @hm_nota.orden
    click_on "Update Hm nota"

    assert_text "Hm nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Hm nota" do
    visit hm_nota_url(@hm_nota)
    click_on "Destroy this hm nota", match: :first

    assert_text "Hm nota was successfully destroyed"
  end
end
