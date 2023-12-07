require 'test_helper'

class AgeActividadesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_actividad = age_actividades(:one)
  end

  test "should get index" do
    get age_actividades_url
    assert_response :success
  end

  test "should get new" do
    get new_age_actividad_url
    assert_response :success
  end

  test "should create age_actividad" do
    assert_difference('AgeActividad.count') do
      post age_actividades_url, params: { age_actividad: { age_actividad: @age_actividad.age_actividad, app_perfil_id: @age_actividad.app_perfil_id, estado: @age_actividad.estado, owner_class: @age_actividad.owner_class, owner_id: @age_actividad.owner_id, tipo: @age_actividad.tipo } }
    end

    assert_redirected_to age_actividad_url(AgeActividad.last)
  end

  test "should show age_actividad" do
    get age_actividad_url(@age_actividad)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_actividad_url(@age_actividad)
    assert_response :success
  end

  test "should update age_actividad" do
    patch age_actividad_url(@age_actividad), params: { age_actividad: { age_actividad: @age_actividad.age_actividad, app_perfil_id: @age_actividad.app_perfil_id, estado: @age_actividad.estado, owner_class: @age_actividad.owner_class, owner_id: @age_actividad.owner_id, tipo: @age_actividad.tipo } }
    assert_redirected_to age_actividad_url(@age_actividad)
  end

  test "should destroy age_actividad" do
    assert_difference('AgeActividad.count', -1) do
      delete age_actividad_url(@age_actividad)
    end

    assert_redirected_to age_actividades_url
  end
end
