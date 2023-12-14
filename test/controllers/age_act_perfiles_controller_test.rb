require 'test_helper'

class AgeActPerfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_act_perfil = age_act_perfiles(:one)
  end

  test "should get index" do
    get age_act_perfiles_url
    assert_response :success
  end

  test "should get new" do
    get new_age_act_perfil_url
    assert_response :success
  end

  test "should create age_act_perfil" do
    assert_difference('AgeActPerfil.count') do
      post age_act_perfiles_url, params: { age_act_perfil: { age_actividad_id: @age_act_perfil.age_actividad_id, app_perfil_id: @age_act_perfil.app_perfil_id } }
    end

    assert_redirected_to age_act_perfil_url(AgeActPerfil.last)
  end

  test "should show age_act_perfil" do
    get age_act_perfil_url(@age_act_perfil)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_act_perfil_url(@age_act_perfil)
    assert_response :success
  end

  test "should update age_act_perfil" do
    patch age_act_perfil_url(@age_act_perfil), params: { age_act_perfil: { age_actividad_id: @age_act_perfil.age_actividad_id, app_perfil_id: @age_act_perfil.app_perfil_id } }
    assert_redirected_to age_act_perfil_url(@age_act_perfil)
  end

  test "should destroy age_act_perfil" do
    assert_difference('AgeActPerfil.count', -1) do
      delete age_act_perfil_url(@age_act_perfil)
    end

    assert_redirected_to age_act_perfiles_url
  end
end
