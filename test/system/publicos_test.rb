require "application_system_test_case"

class PublicosTest < ApplicationSystemTestCase
  setup do
    @publico = publicos(:one)
  end

  test "visiting the index" do
    visit publicos_url
    assert_selector "h1", text: "Publicos"
  end

  test "creating a Publico" do
    visit publicos_url
    click_on "New Publico"

    click_on "Create Publico"

    assert_text "Publico was successfully created"
    click_on "Back"
  end

  test "updating a Publico" do
    visit publicos_url
    click_on "Edit", match: :first

    click_on "Update Publico"

    assert_text "Publico was successfully updated"
    click_on "Back"
  end

  test "destroying a Publico" do
    visit publicos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Publico was successfully destroyed"
  end
end
