require 'test_helper'

class AgeUsuPerfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_usu_perfil = age_usu_perfiles(:one)
  end

  test "should get index" do
    get age_usu_perfiles_url
    assert_response :success
  end

  test "should get new" do
    get new_age_usu_perfil_url
    assert_response :success
  end

  test "should create age_usu_perfil" do
    assert_difference('AgeUsuPerfil.count') do
      post age_usu_perfiles_url, params: { age_usu_perfil: { age_usuario_id: @age_usu_perfil.age_usuario_id, app_perfil_id: @age_usu_perfil.app_perfil_id } }
    end

    assert_redirected_to age_usu_perfil_url(AgeUsuPerfil.last)
  end

  test "should show age_usu_perfil" do
    get age_usu_perfil_url(@age_usu_perfil)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_usu_perfil_url(@age_usu_perfil)
    assert_response :success
  end

  test "should update age_usu_perfil" do
    patch age_usu_perfil_url(@age_usu_perfil), params: { age_usu_perfil: { age_usuario_id: @age_usu_perfil.age_usuario_id, app_perfil_id: @age_usu_perfil.app_perfil_id } }
    assert_redirected_to age_usu_perfil_url(@age_usu_perfil)
  end

  test "should destroy age_usu_perfil" do
    assert_difference('AgeUsuPerfil.count', -1) do
      delete age_usu_perfil_url(@age_usu_perfil)
    end

    assert_redirected_to age_usu_perfiles_url
  end
end
