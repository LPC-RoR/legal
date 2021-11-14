require 'test_helper'

class AppContactosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_contacto = app_contactos(:one)
  end

  test "should get index" do
    get app_contactos_url
    assert_response :success
  end

  test "should get new" do
    get new_app_contacto_url
    assert_response :success
  end

  test "should create app_contacto" do
    assert_difference('AppContacto.count') do
      post app_contactos_url, params: { app_contacto: { email: @app_contacto.email, nombre: @app_contacto.nombre, owner_class: @app_contacto.owner_class, owner_id: @app_contacto.owner_id, telefono: @app_contacto.telefono } }
    end

    assert_redirected_to app_contacto_url(AppContacto.last)
  end

  test "should show app_contacto" do
    get app_contacto_url(@app_contacto)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_contacto_url(@app_contacto)
    assert_response :success
  end

  test "should update app_contacto" do
    patch app_contacto_url(@app_contacto), params: { app_contacto: { email: @app_contacto.email, nombre: @app_contacto.nombre, owner_class: @app_contacto.owner_class, owner_id: @app_contacto.owner_id, telefono: @app_contacto.telefono } }
    assert_redirected_to app_contacto_url(@app_contacto)
  end

  test "should destroy app_contacto" do
    assert_difference('AppContacto.count', -1) do
      delete app_contacto_url(@app_contacto)
    end

    assert_redirected_to app_contactos_url
  end
end
