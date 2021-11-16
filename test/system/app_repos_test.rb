require "application_system_test_case"

class AppReposTest < ApplicationSystemTestCase
  setup do
    @app_repo = app_repos(:one)
  end

  test "visiting the index" do
    visit app_repos_url
    assert_selector "h1", text: "App Repos"
  end

  test "creating a App repo" do
    visit app_repos_url
    click_on "New App Repo"

    fill_in "Owner class", with: @app_repo.owner_class
    fill_in "Owner", with: @app_repo.owner_id
    fill_in "Repositorio", with: @app_repo.repositorio
    click_on "Create App repo"

    assert_text "App repo was successfully created"
    click_on "Back"
  end

  test "updating a App repo" do
    visit app_repos_url
    click_on "Edit", match: :first

    fill_in "Owner class", with: @app_repo.owner_class
    fill_in "Owner", with: @app_repo.owner_id
    fill_in "Repositorio", with: @app_repo.repositorio
    click_on "Update App repo"

    assert_text "App repo was successfully updated"
    click_on "Back"
  end

  test "destroying a App repo" do
    visit app_repos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "App repo was successfully destroyed"
  end
end
