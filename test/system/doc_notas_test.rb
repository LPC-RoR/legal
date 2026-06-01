require "application_system_test_case"

class DocNotasTest < ApplicationSystemTestCase
  setup do
    @doc_nota = doc_notas(:one)
  end

  test "visiting the index" do
    visit doc_notas_url
    assert_selector "h1", text: "Doc notas"
  end

  test "should create doc nota" do
    visit doc_notas_url
    click_on "New doc nota"

    fill_in "Nota", with: @doc_nota.nota
    fill_in "Ownr", with: @doc_nota.ownr_id
    fill_in "Ownr type", with: @doc_nota.ownr_type
    click_on "Create Doc nota"

    assert_text "Doc nota was successfully created"
    click_on "Back"
  end

  test "should update Doc nota" do
    visit doc_nota_url(@doc_nota)
    click_on "Edit this doc nota", match: :first

    fill_in "Nota", with: @doc_nota.nota
    fill_in "Ownr", with: @doc_nota.ownr_id
    fill_in "Ownr type", with: @doc_nota.ownr_type
    click_on "Update Doc nota"

    assert_text "Doc nota was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc nota" do
    visit doc_nota_url(@doc_nota)
    click_on "Destroy this doc nota", match: :first

    assert_text "Doc nota was successfully destroyed"
  end
end
