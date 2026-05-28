require "application_system_test_case"

class DocCartolasTest < ApplicationSystemTestCase
  setup do
    @doc_cartola = doc_cartolas(:one)
  end

  test "visiting the index" do
    visit doc_cartolas_url
    assert_selector "h1", text: "Doc cartolas"
  end

  test "should create doc cartola" do
    visit doc_cartolas_url
    click_on "New doc cartola"

    fill_in "Numero cartola", with: @doc_cartola.numero_cartola
    click_on "Create Doc cartola"

    assert_text "Doc cartola was successfully created"
    click_on "Back"
  end

  test "should update Doc cartola" do
    visit doc_cartola_url(@doc_cartola)
    click_on "Edit this doc cartola", match: :first

    fill_in "Numero cartola", with: @doc_cartola.numero_cartola
    click_on "Update Doc cartola"

    assert_text "Doc cartola was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc cartola" do
    visit doc_cartola_url(@doc_cartola)
    click_on "Destroy this doc cartola", match: :first

    assert_text "Doc cartola was successfully destroyed"
  end
end
