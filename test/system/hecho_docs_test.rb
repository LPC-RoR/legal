require "application_system_test_case"

class HechoDocsTest < ApplicationSystemTestCase
  setup do
    @hecho_doc = hecho_docs(:one)
  end

  test "visiting the index" do
    visit hecho_docs_url
    assert_selector "h1", text: "Hecho Docs"
  end

  test "creating a Hecho doc" do
    visit hecho_docs_url
    click_on "New Hecho Doc"

    fill_in "App documento", with: @hecho_doc.app_documento_id
    fill_in "Establece", with: @hecho_doc.establece
    fill_in "Hecho", with: @hecho_doc.hecho_id
    click_on "Create Hecho doc"

    assert_text "Hecho doc was successfully created"
    click_on "Back"
  end

  test "updating a Hecho doc" do
    visit hecho_docs_url
    click_on "Edit", match: :first

    fill_in "App documento", with: @hecho_doc.app_documento_id
    fill_in "Establece", with: @hecho_doc.establece
    fill_in "Hecho", with: @hecho_doc.hecho_id
    click_on "Update Hecho doc"

    assert_text "Hecho doc was successfully updated"
    click_on "Back"
  end

  test "destroying a Hecho doc" do
    visit hecho_docs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Hecho doc was successfully destroyed"
  end
end
