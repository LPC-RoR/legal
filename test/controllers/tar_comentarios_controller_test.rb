require 'test_helper'

class TarComentariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tar_comentario = tar_comentarios(:one)
  end

  test "should get index" do
    get tar_comentarios_url
    assert_response :success
  end

  test "should get new" do
    get new_tar_comentario_url
    assert_response :success
  end

  test "should create tar_comentario" do
    assert_difference('TarComentario.count') do
      post tar_comentarios_url, params: { tar_comentario: { comentario: @tar_comentario.comentario, formula: @tar_comentario.formula, opcional: @tar_comentario.opcional, orden: @tar_comentario.orden, tar_pago_id: @tar_comentario.tar_pago_id, tipo: @tar_comentario.tipo } }
    end

    assert_redirected_to tar_comentario_url(TarComentario.last)
  end

  test "should show tar_comentario" do
    get tar_comentario_url(@tar_comentario)
    assert_response :success
  end

  test "should get edit" do
    get edit_tar_comentario_url(@tar_comentario)
    assert_response :success
  end

  test "should update tar_comentario" do
    patch tar_comentario_url(@tar_comentario), params: { tar_comentario: { comentario: @tar_comentario.comentario, formula: @tar_comentario.formula, opcional: @tar_comentario.opcional, orden: @tar_comentario.orden, tar_pago_id: @tar_comentario.tar_pago_id, tipo: @tar_comentario.tipo } }
    assert_redirected_to tar_comentario_url(@tar_comentario)
  end

  test "should destroy tar_comentario" do
    assert_difference('TarComentario.count', -1) do
      delete tar_comentario_url(@tar_comentario)
    end

    assert_redirected_to tar_comentarios_url
  end
end
