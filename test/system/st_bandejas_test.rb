require "application_system_test_case"

class StBandejasTest < ApplicationSystemTestCase
  setup do
    @st_bandeja = st_bandejas(:one)
  end

  test "visiting the index" do
    visit st_bandejas_url
    assert_selector "h1", text: "St Bandejas"
  end

  test "creating a St bandeja" do
    visit st_bandejas_url
    click_on "New St Bandeja"

    click_on "Create St bandeja"

    assert_text "St bandeja was successfully created"
    click_on "Back"
  end

  test "updating a St bandeja" do
    visit st_bandejas_url
    click_on "Edit", match: :first

    click_on "Update St bandeja"

    assert_text "St bandeja was successfully updated"
    click_on "Back"
  end

  test "destroying a St bandeja" do
    visit st_bandejas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "St bandeja was successfully destroyed"
  end
end
