require "test_helper"

class TipoDenunciadosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_denunciado = tipo_denunciados(:one)
  end

  test "should get index" do
    get tipo_denunciados_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_denunciado_url
    assert_response :success
  end

  test "should create tipo_denunciado" do
    assert_difference("TipoDenunciado.count") do
      post tipo_denunciados_url, params: { tipo_denunciado: { tipo_denunciado: @tipo_denunciado.tipo_denunciado } }
    end

    assert_redirected_to tipo_denunciado_url(TipoDenunciado.last)
  end

  test "should show tipo_denunciado" do
    get tipo_denunciado_url(@tipo_denunciado)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_denunciado_url(@tipo_denunciado)
    assert_response :success
  end

  test "should update tipo_denunciado" do
    patch tipo_denunciado_url(@tipo_denunciado), params: { tipo_denunciado: { tipo_denunciado: @tipo_denunciado.tipo_denunciado } }
    assert_redirected_to tipo_denunciado_url(@tipo_denunciado)
  end

  test "should destroy tipo_denunciado" do
    assert_difference("TipoDenunciado.count", -1) do
      delete tipo_denunciado_url(@tipo_denunciado)
    end

    assert_redirected_to tipo_denunciados_url
  end
end
