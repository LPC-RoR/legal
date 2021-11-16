require 'test_helper'

class AppArchivosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_archivo = app_archivos(:one)
  end

  test "should get index" do
    get app_archivos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_archivo_url
    assert_response :success
  end

  test "should create app_archivo" do
    assert_difference('AppArchivo.count') do
      post app_archivos_url, params: { app_archivo: { archivo: @app_archivo.archivo, owner_class: @app_archivo.owner_class, owner_id: @app_archivo.owner_id } }
    end

    assert_redirected_to app_archivo_url(AppArchivo.last)
  end

  test "should show app_archivo" do
    get app_archivo_url(@app_archivo)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_archivo_url(@app_archivo)
    assert_response :success
  end

  test "should update app_archivo" do
    patch app_archivo_url(@app_archivo), params: { app_archivo: { archivo: @app_archivo.archivo, owner_class: @app_archivo.owner_class, owner_id: @app_archivo.owner_id } }
    assert_redirected_to app_archivo_url(@app_archivo)
  end

  test "should destroy app_archivo" do
    assert_difference('AppArchivo.count', -1) do
      delete app_archivo_url(@app_archivo)
    end

    assert_redirected_to app_archivos_url
  end
end
