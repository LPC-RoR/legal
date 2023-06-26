require "application_system_test_case"

class MItemsTest < ApplicationSystemTestCase
  setup do
    @m_item = m_items(:one)
  end

  test "visiting the index" do
    visit m_items_url
    assert_selector "h1", text: "M Items"
  end

  test "creating a M item" do
    visit m_items_url
    click_on "New M Item"

    fill_in "M item", with: @m_item.m_item
    fill_in "Orden", with: @m_item.orden
    click_on "Create M item"

    assert_text "M item was successfully created"
    click_on "Back"
  end

  test "updating a M item" do
    visit m_items_url
    click_on "Edit", match: :first

    fill_in "M item", with: @m_item.m_item
    fill_in "Orden", with: @m_item.orden
    click_on "Update M item"

    assert_text "M item was successfully updated"
    click_on "Back"
  end

  test "destroying a M item" do
    visit m_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "M item was successfully destroyed"
  end
end
