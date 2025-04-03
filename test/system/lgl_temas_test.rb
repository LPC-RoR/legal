require "application_system_test_case"

class LglTemasTest < ApplicationSystemTestCase
  setup do
    @lgl_tema = lgl_temas(:one)
  end

  test "visiting the index" do
    visit lgl_temas_url
    assert_selector "h1", text: "Lgl temas"
  end

  test "should create lgl tema" do
    visit lgl_temas_url
    click_on "New lgl tema"

    check "Heredado" if @lgl_tema.heredado
    fill_in "Lgl tema", with: @lgl_tema.lgl_tema
    fill_in "Orden", with: @lgl_tema.orden
    fill_in "Ownr", with: @lgl_tema.ownr_id
    fill_in "Ownr type", with: @lgl_tema.ownr_type
    click_on "Create Lgl tema"

    assert_text "Lgl tema was successfully created"
    click_on "Back"
  end

  test "should update Lgl tema" do
    visit lgl_tema_url(@lgl_tema)
    click_on "Edit this lgl tema", match: :first

    check "Heredado" if @lgl_tema.heredado
    fill_in "Lgl tema", with: @lgl_tema.lgl_tema
    fill_in "Orden", with: @lgl_tema.orden
    fill_in "Ownr", with: @lgl_tema.ownr_id
    fill_in "Ownr type", with: @lgl_tema.ownr_type
    click_on "Update Lgl tema"

    assert_text "Lgl tema was successfully updated"
    click_on "Back"
  end

  test "should destroy Lgl tema" do
    visit lgl_tema_url(@lgl_tema)
    click_on "Destroy this lgl tema", match: :first

    assert_text "Lgl tema was successfully destroyed"
  end
end
