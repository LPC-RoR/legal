require 'test_helper'

class AppObservacionesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_observacion = app_observaciones(:one)
  end

  test "should get index" do
    get app_observaciones_url
    assert_response :success
  end

  test "should get new" do
    get new_app_observacion_url
    assert_response :success
  end

  test "should create app_observacion" do
    assert_difference('AppObservacion.count') do
      post app_observaciones_url, params: { app_observacion: { detalle: @app_observacion.detalle, owner_class: @app_observacion.owner_class, owner_id: @app_observacion.owner_id, perfil_id: @app_observacion.perfil_id } }
    end

    assert_redirected_to app_observacion_url(AppObservacion.last)
  end

  test "should show app_observacion" do
    get app_observacion_url(@app_observacion)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_observacion_url(@app_observacion)
    assert_response :success
  end

  test "should update app_observacion" do
    patch app_observacion_url(@app_observacion), params: { app_observacion: { detalle: @app_observacion.detalle, owner_class: @app_observacion.owner_class, owner_id: @app_observacion.owner_id, perfil_id: @app_observacion.perfil_id } }
    assert_redirected_to app_observacion_url(@app_observacion)
  end

  test "should destroy app_observacion" do
    assert_difference('AppObservacion.count', -1) do
      delete app_observacion_url(@app_observacion)
    end

    assert_redirected_to app_observaciones_url
  end
end
