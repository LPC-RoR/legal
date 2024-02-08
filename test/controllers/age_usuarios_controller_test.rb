require 'test_helper'

class AgeUsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @age_usuario = age_usuarios(:one)
  end

  test "should get index" do
    get age_usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_age_usuario_url
    assert_response :success
  end

  test "should create age_usuario" do
    assert_difference('AgeUsuario.count') do
      post age_usuarios_url, params: { age_usuario: { age_usuario: @age_usuario.age_usuario, owner_class: @age_usuario.owner_class, owner_id: @age_usuario.owner_id } }
    end

    assert_redirected_to age_usuario_url(AgeUsuario.last)
  end

  test "should show age_usuario" do
    get age_usuario_url(@age_usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_age_usuario_url(@age_usuario)
    assert_response :success
  end

  test "should update age_usuario" do
    patch age_usuario_url(@age_usuario), params: { age_usuario: { age_usuario: @age_usuario.age_usuario, owner_class: @age_usuario.owner_class, owner_id: @age_usuario.owner_id } }
    assert_redirected_to age_usuario_url(@age_usuario)
  end

  test "should destroy age_usuario" do
    assert_difference('AgeUsuario.count', -1) do
      delete age_usuario_url(@age_usuario)
    end

    assert_redirected_to age_usuarios_url
  end
end
