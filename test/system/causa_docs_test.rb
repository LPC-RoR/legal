require "application_system_test_case"

class CausaDocsTest < ApplicationSystemTestCase
  setup do
    @causa_doc = causa_docs(:one)
  end

  test "visiting the index" do
    visit causa_docs_url
    assert_selector "h1", text: "Causa Docs"
  end

  test "creating a Causa doc" do
    visit causa_docs_url
    click_on "New Causa Doc"

    fill_in "App documento", with: @causa_doc.app_documento_id
    fill_in "Causa", with: @causa_doc.causa_id
    click_on "Create Causa doc"

    assert_text "Causa doc was successfully created"
    click_on "Back"
  end

  test "updating a Causa doc" do
    visit causa_docs_url
    click_on "Edit", match: :first

    fill_in "App documento", with: @causa_doc.app_documento_id
    fill_in "Causa", with: @causa_doc.causa_id
    click_on "Update Causa doc"

    assert_text "Causa doc was successfully updated"
    click_on "Back"
  end

  test "destroying a Causa doc" do
    visit causa_docs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Causa doc was successfully destroyed"
  end
end
