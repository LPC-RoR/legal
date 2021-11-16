require 'test_helper'

class AppReposControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_repo = app_repos(:one)
  end

  test "should get index" do
    get app_repos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_repo_url
    assert_response :success
  end

  test "should create app_repo" do
    assert_difference('AppRepo.count') do
      post app_repos_url, params: { app_repo: { owner_class: @app_repo.owner_class, owner_id: @app_repo.owner_id, repositorio: @app_repo.repositorio } }
    end

    assert_redirected_to app_repo_url(AppRepo.last)
  end

  test "should show app_repo" do
    get app_repo_url(@app_repo)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_repo_url(@app_repo)
    assert_response :success
  end

  test "should update app_repo" do
    patch app_repo_url(@app_repo), params: { app_repo: { owner_class: @app_repo.owner_class, owner_id: @app_repo.owner_id, repositorio: @app_repo.repositorio } }
    assert_redirected_to app_repo_url(@app_repo)
  end

  test "should destroy app_repo" do
    assert_difference('AppRepo.count', -1) do
      delete app_repo_url(@app_repo)
    end

    assert_redirected_to app_repos_url
  end
end
