require 'test_helper'

class AppNominasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_nomina = app_nominas(:one)
  end

  test "should get index" do
    get app_nominas_url
    assert_response :success
  end

  test "should get new" do
    get new_app_nomina_url
    assert_response :success
  end

  test "should create app_nomina" do
    assert_difference('AppNomina.count') do
      post app_nominas_url, params: { app_nomina: { email: @app_nomina.email, nombre: @app_nomina.nombre, tipo: @app_nomina.tipo } }
    end

    assert_redirected_to app_nomina_url(AppNomina.last)
  end

  test "should show app_nomina" do
    get app_nomina_url(@app_nomina)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_nomina_url(@app_nomina)
    assert_response :success
  end

  test "should update app_nomina" do
    patch app_nomina_url(@app_nomina), params: { app_nomina: { email: @app_nomina.email, nombre: @app_nomina.nombre, tipo: @app_nomina.tipo } }
    assert_redirected_to app_nomina_url(@app_nomina)
  end

  test "should destroy app_nomina" do
    assert_difference('AppNomina.count', -1) do
      delete app_nomina_url(@app_nomina)
    end

    assert_redirected_to app_nominas_url
  end
end
