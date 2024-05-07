require 'test_helper'

class AutTipoUsuariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aut_tipo_usuario = aut_tipo_usuarios(:one)
  end

  test "should get index" do
    get aut_tipo_usuarios_url
    assert_response :success
  end

  test "should get new" do
    get new_aut_tipo_usuario_url
    assert_response :success
  end

  test "should create aut_tipo_usuario" do
    assert_difference('AutTipoUsuario.count') do
      post aut_tipo_usuarios_url, params: { aut_tipo_usuario: { aut_tipo_usuario: @aut_tipo_usuario.aut_tipo_usuario } }
    end

    assert_redirected_to aut_tipo_usuario_url(AutTipoUsuario.last)
  end

  test "should show aut_tipo_usuario" do
    get aut_tipo_usuario_url(@aut_tipo_usuario)
    assert_response :success
  end

  test "should get edit" do
    get edit_aut_tipo_usuario_url(@aut_tipo_usuario)
    assert_response :success
  end

  test "should update aut_tipo_usuario" do
    patch aut_tipo_usuario_url(@aut_tipo_usuario), params: { aut_tipo_usuario: { aut_tipo_usuario: @aut_tipo_usuario.aut_tipo_usuario } }
    assert_redirected_to aut_tipo_usuario_url(@aut_tipo_usuario)
  end

  test "should destroy aut_tipo_usuario" do
    assert_difference('AutTipoUsuario.count', -1) do
      delete aut_tipo_usuario_url(@aut_tipo_usuario)
    end

    assert_redirected_to aut_tipo_usuarios_url
  end
end
