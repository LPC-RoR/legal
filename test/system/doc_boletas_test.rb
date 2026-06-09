require "application_system_test_case"

class DocBoletasTest < ApplicationSystemTestCase
  setup do
    @doc_boleta = doc_boletas(:one)
  end

  test "visiting the index" do
    visit doc_boletas_url
    assert_selector "h1", text: "Doc boletas"
  end

  test "should create doc boleta" do
    visit doc_boletas_url
    click_on "New doc boleta"

    fill_in "Emisor rut", with: @doc_boleta.emisor_rut
    click_on "Create Doc boleta"

    assert_text "Doc boleta was successfully created"
    click_on "Back"
  end

  test "should update Doc boleta" do
    visit doc_boleta_url(@doc_boleta)
    click_on "Edit this doc boleta", match: :first

    fill_in "Emisor rut", with: @doc_boleta.emisor_rut
    click_on "Update Doc boleta"

    assert_text "Doc boleta was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc boleta" do
    visit doc_boleta_url(@doc_boleta)
    click_on "Destroy this doc boleta", match: :first

    assert_text "Doc boleta was successfully destroyed"
  end
end
