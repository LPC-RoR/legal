require 'test_helper'

class AppRepositoriosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_repositorio = app_repositorios(:one)
  end

  test "should get index" do
    get app_repositorios_url
    assert_response :success
  end

  test "should get new" do
    get new_app_repositorio_url
    assert_response :success
  end

  test "should create app_repositorio" do
    assert_difference('AppRepositorio.count') do
      post app_repositorios_url, params: { app_repositorio: { app_repositorio: @app_repositorio.app_repositorio, owner_class: @app_repositorio.owner_class, owner_id: @app_repositorio.owner_id } }
    end

    assert_redirected_to app_repositorio_url(AppRepositorio.last)
  end

  test "should show app_repositorio" do
    get app_repositorio_url(@app_repositorio)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_repositorio_url(@app_repositorio)
    assert_response :success
  end

  test "should update app_repositorio" do
    patch app_repositorio_url(@app_repositorio), params: { app_repositorio: { app_repositorio: @app_repositorio.app_repositorio, owner_class: @app_repositorio.owner_class, owner_id: @app_repositorio.owner_id } }
    assert_redirected_to app_repositorio_url(@app_repositorio)
  end

  test "should destroy app_repositorio" do
    assert_difference('AppRepositorio.count', -1) do
      delete app_repositorio_url(@app_repositorio)
    end

    assert_redirected_to app_repositorios_url
  end
end
