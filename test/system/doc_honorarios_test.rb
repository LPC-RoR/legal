require "application_system_test_case"

class DocHonorariosTest < ApplicationSystemTestCase
  setup do
    @doc_honorario = doc_honorarios(:one)
  end

  test "visiting the index" do
    visit doc_honorarios_url
    assert_selector "h1", text: "Doc honorarios"
  end

  test "should create doc honorario" do
    visit doc_honorarios_url
    click_on "New doc honorario"

    fill_in "Contribuyente rut", with: @doc_honorario.contribuyente_rut
    click_on "Create Doc honorario"

    assert_text "Doc honorario was successfully created"
    click_on "Back"
  end

  test "should update Doc honorario" do
    visit doc_honorario_url(@doc_honorario)
    click_on "Edit this doc honorario", match: :first

    fill_in "Contribuyente rut", with: @doc_honorario.contribuyente_rut
    click_on "Update Doc honorario"

    assert_text "Doc honorario was successfully updated"
    click_on "Back"
  end

  test "should destroy Doc honorario" do
    visit doc_honorario_url(@doc_honorario)
    click_on "Destroy this doc honorario", match: :first

    assert_text "Doc honorario was successfully destroyed"
  end
end
