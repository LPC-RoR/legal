require "application_system_test_case"

class HLinksTest < ApplicationSystemTestCase
  setup do
    @h_link = h_links(:one)
  end

  test "visiting the index" do
    visit h_links_url
    assert_selector "h1", text: "H Links"
  end

  test "creating a H link" do
    visit h_links_url
    click_on "New H Link"

    fill_in "Link", with: @h_link.link
    fill_in "Texto", with: @h_link.texto
    click_on "Create H link"

    assert_text "H link was successfully created"
    click_on "Back"
  end

  test "updating a H link" do
    visit h_links_url
    click_on "Edit", match: :first

    fill_in "Link", with: @h_link.link
    fill_in "Texto", with: @h_link.texto
    click_on "Update H link"

    assert_text "H link was successfully updated"
    click_on "Back"
  end

  test "destroying a H link" do
    visit h_links_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "H link was successfully destroyed"
  end
end
