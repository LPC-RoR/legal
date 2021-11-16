require "application_system_test_case"

class AppDirDiresTest < ApplicationSystemTestCase
  setup do
    @app_dir_dir = app_dir_dires(:one)
  end

  test "visiting the index" do
    visit app_dir_dires_url
    assert_selector "h1", text: "App Dir Dires"
  end

  test "creating a App dir dir" do
    visit app_dir_dires_url
    click_on "New App Dir Dir"

    fill_in "Child", with: @app_dir_dir.child_id
    fill_in "Parent", with: @app_dir_dir.parent_id
    click_on "Create App dir dir"

    assert_text "App dir dir was successfully created"
    click_on "Back"
  end

  test "updating a App dir dir" do
    visit app_dir_dires_url
    click_on "Edit", match: :first

    fill_in "Child", with: @app_dir_dir.child_id
    fill_in "Parent", with: @app_dir_dir.parent_id
    click_on "Update App dir dir"

    assert_text "App dir dir was successfully updated"
    click_on "Back"
  end

  test "destroying a App dir dir" do
    visit app_dir_dires_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App dir dir was successfully destroyed"
  end
end
